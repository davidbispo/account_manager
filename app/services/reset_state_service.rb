module Services
  class ResetStateService
    def perform(db_instance)
      accounts = db_instance.from(:accounts)
      accounts.delete
      accounts.insert(id: 300, balance: 0)
      return true
    end
  end
end