module Services
  module Account
    class CreateAndDepositToAccountService
      attr_reader :result

      def perform(account_id, deposit=0)
        
        current_account = Account.find(account_id)

        if current_account
          @result = Services::CreateAccountService(account_id, deposit)
        else
          @result = Services::DepositToAccountService(account_id, deposit)
        end
      end

      def response
        return { status: 500, result: 'error' } unless result
        
        { 
          status: 200, 
          result: {
            id:result[:id].to_s,
            balance:result[:balance]
          }.to_json 
        }
      end
    end
  end
end