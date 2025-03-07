require 'sinatra'
require 'sequel'
require 'pry'
require_relative 'database.rb'
require_relative "models/user"
require_relative "models/product"
require_relative "models/operation"
require_relative "models/template"
require_relative "models/position"

require_relative "actions/post_operation"
require_relative "actions/post_submit"

class ParamsParser
  def initialize(request)
    @params = JSON.parse(request.body.read)
  end

  def call
    yield(@params)
  end
end

post "/operation" do
  ParamsParser.new(request).call do |params|
    PostOperation.new(params).call
  end
end

post "/submit" do 
  ParamsParser.new(request).call do |params|
    PostSubmit.new(params).call
  end
end