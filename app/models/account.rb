require 'hashie'

class Account
  class << self
    def serialized(args)
      Hashie::Mash.new(args)
    end

    def find(id)
      record = account_dataset(id: id).first
      return nil unless record
      serialized(record)
    end

    def create(account_id:, balance:)
      created_id = account_dataset
        .insert(id: account_id, balance: balance)
      
      output = account_dataset
        .where(id: created_id).first
      serialized(output)
    end

    def update(account_id, **args)
      current_dataset = account_dataset(id:account_id)
      current_dataset.update(args)
      output = current_dataset.first
      serialized(output)
    end

    def table_connection
      Connections::AccountManager.connection.from(:accounts)
    end

    def account_dataset(**args)
      table_connection.where(args)
    end
  end
end