require 'naborly/ruby'

RSpec.describe Naborly::Ruby::Client do
  let(:naborly_client) { Naborly::Ruby::Client.new }

  describe '#authenticate!' do
    it 'returns a naborly access token' do
      VCR.use_cassette('authenticate') do
        expect(naborly_client.authenticate!).to be_a Naborly::Ruby::AccessToken
      end
    end

    it 'sets the naborly access token instance variable after authenticating successfully' do
      VCR.use_cassette('authenticate') do
        expect { naborly_client.authenticate! }.to change { naborly_client.access_token }.from(nil)
      end
    end

    it 'raises an error if the credentials are incorrect' do
      VCR.use_cassette('unauthenticated_client') do
        unauthorized_client = Naborly::Ruby::Client.new(client_id: 'bogus_id', client_secret: 'bogus_secret')
        expect { unauthorized_client.authenticate! }.to raise_error(Naborly::Ruby::UnauthenticatedError, 'Code: 401, body: Unauthorized')
      end
    end
  end
end
