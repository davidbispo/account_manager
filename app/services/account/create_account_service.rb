module Services
  module Account
    class CreateAccountService
      def perform(account_id, balance)
        ::Account.create(account_id: account_id, balance:balance)
      end
    end
  end
end