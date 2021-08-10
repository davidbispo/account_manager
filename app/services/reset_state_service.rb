module Services
  class ResetStateService
    def perform(db_instance)
      accounts = db_instance.from(:accounts)
      accounts.delete
      return true
    end
  end
end