require 'sequel'
require_relative '../../../app/api'
DB = Sequel.connect(ENV['DATABASE_URL'])

RSpec.describe 'GET /balance?account_id=account_id' do

  def app
    AccountManager::API
  end

  context "account exists" do
    before do
      @existing_account = DB.from(:accounts).insert(balance:20)
      get("/balance?account_id=#{@existing_account}")
    end

    it "expects a confirmation from the API" do
      expect(last_response.status).to eq(200)
    end

    it "expects body to match template" do
      parsed = JSON.parse(last_response.body)
      expect(parsed).to match(20)
    end

  end

  context "account does not exist" do
    let (:non_existing_account_id) { 99999 }
    it "expects a 404 from the API" do
      get("/balance?account_id=#{non_existing_account_id}")
      expect(last_response.status).to eq(404)
      expect(last_response.body).to eq("0")
    end
  end
end