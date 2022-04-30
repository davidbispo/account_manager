require_relative 'event_processor_strategy'

module Strategies
  class DepositStrategy < Strategies::EventProcessorStrategy
    attr_accessor :account_id, :amount, :result

    def self.should_run_for?(event)
      event == 'deposit'
    end

    def initialize(args)
      @account_id = args["account_id"]
      @amount = args["amount"]
      self
    end

    def resolve
      account = ::Account.find(account_id)
      unless account
        Services::Account::CreateAccountService.new.perform(account_id, amount)
      end
      @result = Services::Account::DepositToAccountService.new.perform(account_id: account_id, amount: amount)
      self
    end

    def response
      if result 
        res = { status: 200, result: result.to_json }
      else
        res = { status: 500, result: 'error' }
      end
      Hashie::Mash.new(res)
    end
  end
end