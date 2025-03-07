# frozen_string_literal: true

require_relative 'base_model'

class Operation < BaseModel
  table_name :operations

  attribute :user_id
  attribute :cashback
  attribute :cashback_percent
  attribute :discount
  attribute :discount_percent
  attribute :write_off
  attribute :check_summ
  attribute :done
  attribute :allowed_write_off
end
