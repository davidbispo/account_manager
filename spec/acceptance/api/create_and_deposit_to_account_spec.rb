require_relative '../../../app/api'
require 'sequel'
require_relative '../../../app/api'
DB = Sequel.connect(ENV['DATABASE_URL'])

RSpec.describe 'POST /event: create and deposit' do
  def app
    AccountManager::API
  end

  context "information is correct" do
    context "and account does not exist" do
      let(:body) { { type:"deposit", destination: 100, amount:10} }
      before do
        post('/event', body.to_json, { 'CONTENT_TYPE' => 'application/json' })
      end

      it "expects body to match template" do
        parsed = JSON.parse(last_response.body)
        expect(parsed).to match(expected_echo_create)
      end
      it { expect(last_response.status).to eq(201) }
    end
    context "and account exists" do

      before do
        @existing_account = DB.from(:accounts).insert(balance:20)
        post('/event', body.to_json, { 'CONTENT_TYPE' => 'application/json' })
      end

      let(:body) { {type: "deposit", destination: 101, amount:10} }

      it "expects 201" do
        expect(last_response.status).to eq(201)
      end

      it "expects body to match template" do
        parsed = JSON.parse(last_response.body)
        expect(parsed).to match(expected_echo_deposit)
      end
    end
  end

  context "information is incorrect" do
    let (:body) { { type: "potato", color: "yellow", size: 10} }

    before do
      post('/event', body.to_json, { 'CONTENT_TYPE' => 'application/json' })
    end

    it "expects a 422" do
      expect(last_response.status).to eq(422)
    end
  end

  def expected_echo_create
    { "destination"=>
      { "id"=> "100",
      "balance"=> 10}
    }
  end
  def expected_echo_deposit
    {
      "destination"=>
      { "id"=> "101",
        "balance"=> 20
      }
    }
  end
end
