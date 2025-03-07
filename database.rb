class Database
  class << self
    def db
      @db ||= Sequel.sqlite("db/test.db")
    end
  end
end