module Services
  class TransferBetweenAccountsService
    def perform(db_instance, origin_account_id, destination_account_id, amount)
      accounts = db_instance.from(:accounts)
      origin_dataset = accounts.where(:id => origin_account_id)
      dest_dataset = accounts.where(:id => destination_account_id)

      origin_account = origin_dataset.first
      dest_account = dest_dataset.first

      return false unless origin_account && dest_account

      new_balance_on_origin = origin_account[:balance] - amount
      origin_dataset.update(balance: new_balance_on_origin)

      new_balance_on_dest = dest_account[:balance] + amount
      dest_dataset.update(balance: new_balance_on_dest)

      return {
        origin:
          {
            id: origin_dataset.first[:id].to_s,
            balance: origin_dataset.first[:balance]
          },
        destination:
        {
          id: dest_dataset.first[:id].to_s,
          balance: dest_dataset.first[:balance]
        }
      }
    end
  end
end