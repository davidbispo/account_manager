require_relative '../../../app/api'


RSpec.describe 'POST /reset' do
  def app
    WalletManager::API
  end

  context "and request is valid" do
    it "expects a correct response from the API" do
      post('/reset')
      expect(last_response.status).to eq(200)
    end
  end
end