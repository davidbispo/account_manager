require_relative '../../../app/api'

RSpec.describe 'POST /event: transfer from account' do
  def app
    WalletManager::API
  end

  context "and account exists" do
    before do
      @existing_origin_account_id = DB.from(:accounts).insert(balance:15)
      @existing_destination_account_id = DB.from(:accounts).insert(balance:0)
      @payload = {"type"=>"transfer", "origin"=> @existing_origin_account_id.to_s, "amount":15, "destination"=>@existing_destination_account_id.to_s}
      post("/event", @payload.to_json, { 'CONTENT_TYPE' => 'application/json' })
    end


    it "expects a correct response from the API" do
      expect(last_response.status).to eq(201)
    end

    it "expects body to match template" do
      parsed = JSON.parse(last_response.body)
      expect(parsed).to match(response_template)
    end
  end

  context "and origin account does not exist" do
    let (:payload) { {"type"=>"transfer", "origin"=>"9999", "amount":15, "destination"=>"303"} }
    before do
      post("/event", payload.to_json, { 'CONTENT_TYPE' => 'application/json' })
    end

    it "expects body to match template" do
      expect(last_response.body).to eq("0")
    end

    it { expect(last_response.status).to eq(404) }
  end

  def response_template
    {"origin"=>{"id"=>@existing_origin_account_id.to_s, "balance"=>0}, "destination"=>{"id"=>@existing_destination_account_id.to_s, "balance"=>15}}
  end
end