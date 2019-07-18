require 'naborly/ruby'
require 'pry'

RSpec.describe Naborly::Ruby::Client do
  let(:naborly_client) { Naborly::Ruby::Client.new }

  describe '#authenticate!' do
    it 'returns a naborly access token' do
      expect(naborly_client.authenticate!).to be_a Naborly::Ruby::AccessToken
    end

    it 'sets the naborly access token instance variable after authenticating successfully' do
      expect { naborly_client.authenticate! }.to change { naborly_client.access_token }.from(nil)
    end

    it 'raises an error if the credentials are incorrect' do
      unauthorized_client = Naborly::Ruby::Client.new(client_id: 'bogus_id', client_secret: 'bogus_secret')
      expect { unauthorized_client.authenticate! }.to raise_error(Naborly::Ruby::UnauthenticatedError, 'Code: 401, body: Unauthorized')
    end
  end
end
