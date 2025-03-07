# frozen_string_literal: true

require_relative 'base_action'

class PostOperation < BaseAction
  attr_accessor :total_sum, :cashback, :discount
  attr_reader :positions_arr

  def initialize(_)
    super
    @total_sum = 0
    @cashback = 0
    @discount = 0
    @formatted_positions = []
  end

  def call
    positions.each do |position|
      pick_position_attributes(position)
    rescue StandardError
      nil
    end

    total_discount = @cashback + @discount
    common_cashback_percent = (@cashback.zero? ? 0 : @total_sum / (@cashback * 100).to_f).ceil(2)
    total_discount_percent = (total_discount.zero? ? 0 : @total_sum / (total_discount * 100).to_f).ceil(2)
    operation = create_operation(common_cashback_percent, total_discount_percent)
    generate_result(operation, common_cashback_percent, total_discount, total_discount_percent).to_json
  end

  private

  def pick_position_attributes(position)
    product = Product.find(position.id)

    sum = position.price * position.quantity
    @total_sum += sum

    product_cashback = 0
    product_discount = 0

    case product.type
    when ->(type) { type == 'increased_cashback' && template.cashback.positive? }
      product_cashback = sum * (template.cashback.to_f / 100)
      @cashback += product_cashback
    when ->(type) { type == 'discount' && template.discount.positive? }
      product_discount = sum * (template.discount.to_f / 100)
      @discount += product_discount
    end

    discount_value = product_cashback + product_discount
    add_formatted_position(discount_value, product_cashback, product_discount)
  end

  def add_formatted_position(discount_value, product_cashback, product_discount)
    formatted_positions << {
      type: product.type,
      value: product.value,
      name: product.name,
      discount_percent: discount_value.to_i.zero? ? 0 : sum / ((product_cashback + product_discount) * 100).to_f,
      discount_value: discount_value
    }
  end

  def create_operation(common_cashback_percent, total_discount_percent)
    Operation.create(
      user_id: user.id,
      cashback: @cashback,
      cashback_percent: common_cashback_percent,
      discount: @discount,
      discount_percent: total_discount_percent,
      check_summ: @total_sum,
      write_off: [user.bonus, @discount].min
    )
  end

  def generate_result(operation, common_cashback_percent, total_discount, total_discount_percent)
    {
      status: 200,
      user: user.to_h,
      operation_id: operation.id,
      total_sum: @total_sum - @cashback - @discount,
      bonuses: {
        user_bonuses: user.bonus,
        available_for_write_off: [user.bonus, @discount].min,
        common_cashback_percent: common_cashback_percent,
        cashback: @cashback
      },
      discount_info: {
        total_discount: total_discount,
        total_discount_percent: total_discount_percent
      },
      positions: @positions_arr
    }
  end

  def user
    @user ||= User.find(params.user_id)
  end

  def template
    @template ||= Template.find(user.template_id)
  end

  def positions
    params.positions.map { |attrs| Position.new(attrs) }
  end
end
