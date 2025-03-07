# frozen_string_literal: true

class BaseAction
  attr_reader :params

  def initialize(params)
    @params = params
  end
end
