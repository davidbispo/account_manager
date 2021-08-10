require 'sinatra/base'
require 'sequel'
require_relative './services/create_and_deposit_to_account_service'
require_relative './services/get_balance_service'
require_relative './services/reset_state_service'
require_relative './services/transfer_between_accounts_service'
require_relative './services/withdraw_from_account_service'

module WalletManager
  class API < Sinatra::Base
    set :server, 'puma'
    require 'json'
    require "sinatra/config_file"

    register Sinatra::ConfigFile

    DB = Sequel.connect(ENV['DATABASE_URL'])

    configure :development, :test do
      require 'byebug'
      require "sinatra/reloader"

      register Sinatra::Reloader
    end

    before do
      if @request.content_type == 'application/json'
        @request.body.rewind
        @request_payload = JSON.parse(request.body.read) rescue nil
      end
    end

    get '/' do
      return { status: "ok" }.to_json
    end

    post '/reset' do
      begin
        result =  Services::ResetStateService.new.perform(DB)
        status 200 if result == true
        return "OK"
      rescue => e
        return e.message.to_json
      end
    end

    get '/balance/:id' do
      result =  Services::GetBalanceService.new.perform(DB, params["id"])
      if result != 'not found'
        status 200
        return result.to_json
      end
        status 404
        return "0"
    end

    post '/event' do
      event = @request_payload
      if event["type"] == 'deposit'
        result = Services::CreateAndDepositToAccountService.new.perform(
          DB,
          event["destination"],
          event["amount"]
        )
        status 201
        return result.to_json#.sub!(":{"," : {")
      end

    if event["type"] == 'transfer'
      result = Services::TransferBetweenAccountsService.new.perform(
        DB,
        event["origin"],
        event["destination"],
        event["amount"]
      )
      halt 400 if result == false
      status 201
      return result.sub!(":{"," : {")
    end

    if event["type"] == 'withdraw'
      result = Services::WithdrawFromAccountService.new.perform(
        DB,
        event["origin"],
        event["amount"]
      )
      status 201
      return result.to_json.sub!(":{"," : {")
    end

    halt 422
    end
  end
end
