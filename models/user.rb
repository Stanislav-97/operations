# frozen_string_literal: true

require_relative 'base_model'

class User < BaseModel
  table_name :users

  attribute :name
  attribute :template_id
  attribute :bonus
end
