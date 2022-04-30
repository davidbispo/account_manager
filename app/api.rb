require 'sinatra/base'
require 'sequel'

module AccountManager
  class API < Sinatra::Base
    set :server, 'puma'
    require 'json'
    require "sinatra/config_file"

    register Sinatra::ConfigFile

    configure :development, :test do
      require "sinatra/reloader"
      require 'byebug'
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
        result =  Services::Domain::ResetStateService.new.perform
        status 200 if result == true
        return "OK"
      rescue => e
        return e.message.to_json
      end
    end

    get '/accounts/:id/balance' do
      result = Services::Account::GetBalanceForAccountService.new(params[:id]).perform.response
      render_json(result.status, result.result)
    end

    post '/event' do
      res = Services::Domain::ResolveEventService.new(@request_payload).resolve
      render_json(res.status, res.result)
    end

    private

    def render_not_found
      status 404
      return "0"
    end

    def render_json(status, json)
      status(status)
      return json
    end
  end
end
