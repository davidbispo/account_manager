module Services
  class GetBalanceService
    def perform(db_instance, account_id)
      accounts = db_instance.from(:accounts)
      dataset = accounts.where(:id => account_id)
      account = dataset.first
      return account[:balance] if account
      return 'not found'
    end
  end
end