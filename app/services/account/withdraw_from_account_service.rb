module Services
  module Account
    class WithdrawFromAccountService
      def perform(account_id:, amount:)
        account = ::Account.find(account_id)
        new_balance = account.balance - amount
        ::Account.update(account_id, balance: new_balance)
        true
      end
    end
  end
end