module Services
  class CreateAndDepositToAccountService
    def perform(db_instance, destination_account_id, deposit=0)
      accounts = db_instance.from(:accounts)
      current_dataset = accounts.where(:id => destination_account_id)
      current_account = current_dataset.first
      if current_account
        new_balance = current_account[:balance] + deposit
        current_dataset.update(balance: new_balance)
        result = current_dataset.first
      else
        created_id = accounts.insert(id: destination_account_id, balance: deposit)
        result = accounts.where(:id => created_id).first
      end

      return {
        destination:
          {
            id:result[:id].to_s,
            balance:result[:balance]
          }
      }
    end
  end
end