require_relative "base_action"

class PostSubmit < BaseAction
  def call
    {
      status: 200,
      message: "ok",
      operation_info: {
        user_id: user.id,
        cashback: operation.cashback,
        cashback_percent: operation.cashback_percent,
        discount: operation.discount,
        discount_percent: operation.discount_percent,
        write_off: operation.write_off,
        check_summ: operation.check_summ
      }
    }.to_json
  end

  private

  def user
    @user ||= User.find(params["user"]["id"])
  end
  
  def operation
    @operation ||= Operation.find(params["operation_id"])
  end
end