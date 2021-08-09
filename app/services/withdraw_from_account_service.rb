module Services
  class WithdrawFromAccountService
    def perform(db_instance, account_id, amount)
      accounts = db_instance.from(:accounts)
      account_dataset = accounts.where(:id => destination_account_id)
      account = origin_dataset.first

      new_balance = account[:balance] - amount
      account_dataset.update(balance: amount)

      return {
        origin:
          {
            id: account[:id],
            balance: account[:balance]
          }
        }
    end
  end
end