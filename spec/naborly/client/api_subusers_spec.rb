require 'naborly/ruby'
require 'pry'

RSpec.describe Naborly::Ruby::Client::ApiSubusers do
  let(:naborly_client) { Naborly::Ruby::Client.new }

  describe '#create_api_subuser' do    
    it 'creates an api subuser with the provided params using an authenticated client' do
      expect {
        naborly_client.add_api_subuser({
          "landlordFirstName" => "Jane",
          "landlordLastName" => "Doe",
          "landlordCompany" => "Jane Doe Inc.",
          "landlordPhone" => "123-123-1234",
          "landlordEmail" => "landlord@example.com"
        })
      }.to raise_error(Naborly::Ruby::ConflictError, 'Code: 409, body: ')
    end
  end
end
