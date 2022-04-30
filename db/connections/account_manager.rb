require 'sequel'
module Connections
  class AccountManager
    @@connection = nil

    def self.connection
      @@connection ||= Sequel.connect(ENV['DATABASE_URL'])
    end
  end
end