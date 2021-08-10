class DatabaseCleaner
  class << self
    def start(db_instance)
        accounts = db_instance.from(:accounts)
        accounts.delete
      return true
    end
  end
end