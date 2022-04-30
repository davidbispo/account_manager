module Services
  class ResetStateService
    def perform
      accounts = Account.table_connection
      accounts.delete
      accounts.insert(id: 300, balance: 0)
      return true
    end
  end
end