require 'naborly/ruby'
require 'pry'

RSpec.describe Naborly::Ruby::Client::ApiSubuser do
  let(:naborly_client) { Naborly::Ruby::Client.new }

  describe '#create_api_subuser' do
    
    it 'raises an error if the client is unauthenticated' do
      unauthorized_client = Naborly::Ruby::Client.new(client_id: 'bogus_id', client_secret: 'bogus_secret')
      expect { unauthorized_client.authenticate! }.to raise_error(Naborly::Ruby::UnauthenticatedError, 'Unauthorized')
    end
  end
end
