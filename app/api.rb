require 'sinatra/base'

module PaymentManager
  class API < Sinatra::Base
    require 'json'

    configure :development, :test do
      require "sinatra/reloader"
      register Sinatra::Reloader
    end

    set :server, 'puma'

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

    end

    get '/balance' do

    end

    post '/event' do

    end

    get '/balance' do

    end
  end
end
