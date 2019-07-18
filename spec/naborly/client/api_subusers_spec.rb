require 'naborly/ruby'
require 'pry'

RSpec.describe Naborly::Ruby::Client::ApiSubusers do
  let(:naborly_client) { Naborly::Ruby::Client.new }

  describe '#create_api_subuser' do    
    it 'raises an error if the client cannot authenticate' do
      unauthorized_client = Naborly::Ruby::Client.new(client_id: 'bogus_id', client_secret: 'bogus_secret')
      expect { unauthorized_client.authenticate! }.to raise_error(Naborly::Ruby::UnauthenticatedError, 'Unauthorized')
    end

    it 'creates an api subuser with the provided params using an authenticated client' do
      naborly_client.add_api_subuser({
        "landlordFirstName" => "Jane",
        "landlordLastName" => "Doe",
        "landlordCompany" => "Jane Doe Inc.",
        "landlordPhone" => "123-123-1234",
        "landlordEmail" => "landlord@example.com"
      })
    end
  end
end
