
require_relative '../../../app/api'

RSpec.describe 'GET /balance?account_id=account_id' do

  def app
    WalletManager::API
  end

  context "account exists" do
    let(:existing_account_id) { 100 }

    before do
      get("/balance/#{existing_account_id}")
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
    let (:non_existing_account_id) { 103 }
    it "expects a 404 from the API" do
      get("/balance/#{non_existing_account_id}")
      expect(last_response.status).to eq(404)
    end
  end
end