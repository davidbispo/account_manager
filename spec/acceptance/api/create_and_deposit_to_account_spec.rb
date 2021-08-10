require_relative '../../../app/api'

RSpec.describe 'POST /event: create and deposit' do
  def app
    WalletManager::API
  end

  before do
    post('/event', body.to_json, { 'CONTENT_TYPE' => 'application/json' })
  end

  context "information is correct" do
    context "and account exists" do
      let(:body) { {"type"=>"deposit", "destination"=>"100", "amount":10} }

      it "expects 201" do
        expect(last_response.status).to eq(201)
      end

      it "expects body to match template" do
        parsed = JSON.parse(last_response.body)
        expect(parsed).to match(expected_echo_deposit)
      end
    end
    context "and account does not exist" do
      let(:body) { {"type"=>"deposit", "destination"=>"101", "amount":10} }

      it "expects 201" do
        expect(last_response.status).to eq(201)
      end

      it "expects body to match template" do
        parsed = JSON.parse(last_response.body)
        expect(parsed).to match(expected_echo_create)
      end
    end
  end

  context "information is incorrect" do
    let (:body) { {"type"=>"potato", "color"=>"yellow", "size":10} }
    it "expects a 422" do
      expect(last_response.status).to eq(422)
    end
  end

  def expected_echo_create
    {"destination"=>{"id"=>"101", "balance"=>10}}
  end
  def expected_echo_deposit
    {"destination"=>{"id"=>"100", "balance"=>20}}
  end
end
