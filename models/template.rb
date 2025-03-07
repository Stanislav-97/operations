require_relative "base_model"

class Template < BaseModel
  table_name :templates

  attribute :name
  attribute :discount
  attribute :cashback
end