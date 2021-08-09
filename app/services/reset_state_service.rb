module Services
  class ResetStateService
    def perform(db_instance)
      accounts = db_instance.from(:accounts)
      dataset = accounts.all
      account = dataset.delete
      return true
    end
  end
end