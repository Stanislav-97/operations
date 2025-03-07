# frozen_string_literal: true

class Database
  class << self
    def db
      @db ||= Sequel.sqlite('db/test.db')
    end
  end
end
