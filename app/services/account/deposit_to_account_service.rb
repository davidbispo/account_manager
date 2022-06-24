module Services
  module Account
    class DepositToAccountService
      def perform(account_id:, amount:)
        current_account = ::Account.find(account_id)
        new_balance = current_account.balance + amount
        ::Account.update(account_id, balance: new_balance)
        true
      end
    end
  end
end