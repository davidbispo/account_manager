require_relative '../../../app/api'
require 'sequel'
require_relative '../../../app/api'
DB = Sequel.connect(ENV['DATABASE_URL'])

RSpec.describe 'POST /reset' do
  def app
    WalletManager::API
  end

  context "and request is valid" do
    it "expects a correct response from the API" do
      post('/reset')
      expect(last_response.status).to eq(200)
      expect(last_response.body).to eq("OK")
    end
  end
end