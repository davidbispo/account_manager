module Services
  class WithdrawFromAccountService
    def perform(db_instance, account_id, amount)
      accounts = db_instance.from(:accounts)
      account_dataset = accounts.where(:id => account_id)
      account = account_dataset.first

      return false unless account

      new_balance = account[:balance] - amount
      account_dataset.update(balance: new_balance)

      return {
        origin:
          {
            id: account_dataset.first[:id].to_s,
            balance: account_dataset.first[:balance]
          }
        }
    end
  end
end