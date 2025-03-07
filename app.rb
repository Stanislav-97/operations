# frozen_string_literal: true

require 'sinatra'
require 'sequel'
require 'pry'
require_relative 'database'
require_relative 'models/user'
require_relative 'models/product'
require_relative 'models/operation'
require_relative 'models/template'
require_relative 'models/position'

require_relative 'actions/post_operation'
require_relative 'actions/post_submit'

class ParamsParser
  def initialize(request)
    @params = generate(JSON.parse(request.body.read))
  end

  def call
    yield(@params)
  end

  private

  def generate(params)
    struct = Struct.new(*params.keys.map(&:to_sym))
    values = extract_values(params)

    struct.new(*values)
  end

  def extract_values(params)
    params.keys.map do |key|
      case params[key]
      when Hash
        generate(params[key])
      when Array
        params[key].map { generate(_1) }
      else
        params[key]
      end
    end
  end
end

post '/operation' do
  ParamsParser.new(request).call do |params|
    PostOperation.new(params).call
  end
end

post '/submit' do
  ParamsParser.new(request).call do |params|
    PostSubmit.new(params).call
  end
end
