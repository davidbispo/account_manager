require_relative '../../../app/api'

RSpec.describe 'POST /event: withdraw' do
  def app
    WalletManager::API
  end

  before do
    @existing_account_id = DB.from(:accounts).insert(balance:20)
    @payload = {"type"=>"withdraw", "origin"=>@existing_account_id, "amount":5}
    post("/event", @payload.to_json, { 'CONTENT_TYPE' => 'application/json' })
  end

  context "and account exists" do
    it "expects a correct response from the API" do
      expect(last_response.status).to eq(201)
    end

    it "expects body to match template" do
      parsed = JSON.parse(last_response.body)
      expect(parsed).to match(response_template)
    end
  end

  context "and account does not exist" do
    let (:payload) { {"type"=>"withdraw", "origin"=>"9999", "amount":5} }
    before do
      post("/event", payload.to_json, { 'CONTENT_TYPE' => 'application/json' })
    end
    it { expect(last_response.status).to eq(404) }
    it { expect(last_response.body).to eq("0") }
  end

  def response_template
    {"origin"=>{"id"=>@existing_account_id.to_s, "balance"=>15}}
  end
end