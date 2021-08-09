module Services
  class TransferBetweenAccountsService
    def perform(db_instance, origin_account_id, destination_account_id, amount)
      accounts = db_instance.from(:accounts)
      origin_dataset = accounts.where(:id => destination_account_id)
      dest_dataset = accounts.where(:id => destination_account_id)

      origin_account = origin_dataset.first
      dest_account = origin_dataset.first

      return false unless origin_account && dest_account

      new_balance_on_origin = origin_account[:balance] - amount
      origin_dataset.update(balance: new_balance_on_origin)

      new_balance_on_dest = dest_account[:balance] + amount
      dest_account.update(balance: new_balance_on_dest)

      return {
        origin:
          {
            id: origin_account[:id],
            balance: origin_account[:balance]
          },
        destination:
        {
          id: dest_account[:id],
          balance: dest_account[:balance]
        }
      }
    end
  end
end