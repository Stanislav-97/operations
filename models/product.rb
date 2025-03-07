require_relative "base_model"

class Product < BaseModel
  table_name :products

  attribute :name
  attribute :type
  attribute :value
end