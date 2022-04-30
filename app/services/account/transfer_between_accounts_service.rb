module Services
  module Account
    class TransferBetweenAccountsService

      public 

      attr_reader :origin_account_id, :destination_account_id, :amount, 
        :updated_origin_dataset, :updated_destination_dataset

      def initialize(args)
        @origin_account_id = args[:origin_account_id]
        @destination_account_id = args[:destination_account_id]
        @amount = args[:amount]
        self
      end

      def perform
        origin_account = ::Account.find(origin_account_id)
        dest_account = ::Account.find(destination_account_id)
        
        return false unless origin_account && dest_account
        
        new_balances = new_balances_after_deposit(origin_account, dest_account, amount)

        sequel_connection.transaction do
          @updated_origin_dataset = origin_account.update(balance: new_balances.origin)
          @updated_destination_dataset = dest_account.update(balance: new_balances.destination)
        end
        true
      end
  
      def sequel_connection
        Connections::AccountManager.connection
      end
  
      def new_balances_after_deposit(origin_account, dest_account, deposit)
        new_balance_on_origin = origin_account.balance - amount
        new_balance_on_dest = dest_account.balance + amount
        Hashie::Mash.new( { origin: new_balance_on_origin, destination: new_balance_on_dest })
      end
    end
  end
end