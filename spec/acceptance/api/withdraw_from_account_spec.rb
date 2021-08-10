require_relative '../../../app/api'

RSpec.describe 'POST /event: withdraw' do
  def app
    WalletManager::API
  end

  before do
    post("/event", payload.to_json, { 'CONTENT_TYPE' => 'application/json' })
  end

  context "and account exists" do
    let (:payload) { {"type"=>"withdraw", "origin"=>"100", "amount":5} }

    it "expects a correct response from the API" do
      expect(last_response.status).to eq(201)
    end

    it "expects body to match template" do
      parsed = JSON.parse(last_response.body)
      expect(parsed).to match(response_template)
    end
  end

  context "and account does not exist" do
    let (:payload) { {"type"=>"withdraw", "origin"=>"103", "amount":5} }
    it { expect(last_response.status).to eq(404) }
  end

  def response_template
    {"origin"=>{"id"=>"100", "balance"=>15}}
  end
end