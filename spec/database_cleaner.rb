class DatabaseCleaner
  class << self
    def start(db_instance)
      accounts = db_instance.from(:accounts)
      accounts_dataset = accounts.all
      accounts_dataset.delete
      return true
    end
  end
end