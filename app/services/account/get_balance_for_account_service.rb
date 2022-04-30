module Services
  module Account
    class GetBalanceForAccountService
      attr_reader :account, :result

      def initialize(account_id)
        @account = ::Account.find(account_id)
        self
      end

      def perform
        @result = account ? { balance: account.balance } : 'not found'
        self
      end

      def response
        if result != 'not found'
          val = { status: 200, result: result.to_json }
        else
          val = { status: 404, result: not_found }
        end
        Hashie::Mash.new(val)
      end
    end
  end
end