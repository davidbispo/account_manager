module Services
  module Account
    class DepositToAccountService
      def perform(account_id:, amount:)
        current_account = ::Account.find(account_id)
        new_amount = current_account.balance + amount
        current_account.update(amount: new_amount)
        true
      end
    end
  end
end