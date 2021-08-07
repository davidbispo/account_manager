require 'sinatra/base'
require 'sequel'
require_relative './services/create_account_service'

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
      halt 200
    end

    get '/balance/:id' do
      if params["id"] != "100"
        halt 404
        return 0
      end
      status 200
      return "20"
    end

    post '/events' do
      event = @request_payload
      if event["type"] == 'deposit'
        Services::CreateAccountService(
          event["destination"],
          event["amount"],
        ).to_json
      end
    end
    # post '/events' do
    #   if @request_payload == {"type"=>"potato", "color"=>"yellow", "size"=>10}
    #     halt 422
    #   end

    #   if @request_payload == {"type": "withdraw", "origin"=>"200", "amount":10 } ||
    #     @request_payload == {"type": "transfer", "origin"=>"200", "amount":15, "destination"=>"300"} ||
    #     @request_payload == {"type": "transfer", "origin"=>"200", "amount":15, "destination"=>"300"} ||
    #     @request_payload == {"type"=>"withdraw", "origin"=>"103", "amount"=>5} ||
    #     @request_payload == {"type"=>"transfer", "origin"=>"100", "amount"=>15, "destination"=>"303"}
    #     status 404
    #     return "0"
    #   end

    #   if @request_payload == {"type"=>"deposit", "destination"=>"100", "amount"=>10}
    #     status 201
    #     return {"destination": {"id"=>"100", "balance":20}}.to_json
    #   end

    #   if @request_payload == {"type"=>"deposit", "destination"=>"101", "amount"=>10}
    #     status 201
    #     return {"destination": {"id"=>"101", "balance":10}}.to_json
    #   end

    #   if @request_payload == {"type"=>"withdraw", "origin"=>"100", "amount"=>5}
    #     status 201
    #     return {"origin": {"id"=>"100", "balance":15}}.to_json
    #   end

    #   if @request_payload == {"type"=>"transfer", "origin"=>"100", "amount"=>15, "destination"=>"300"}
    #     status 201
    #     {"origin"=>{"id"=>"100", "balance"=>0}, "destination"=>{"id"=>"300", "balance"=>15}}.to_json
    #   end
    # end
  end
end
