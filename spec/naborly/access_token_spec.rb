require 'naborly/ruby'
require 'securerandom'

RSpec.describe Naborly::Ruby::AccessToken do
  describe '#expired?' do
    let(:token) { SecureRandom.urlsafe_base64(256) }

    it 'returns true if the access token is expired' do
      access_token = Naborly::Ruby::AccessToken.new({
        access_token: token,
        createdAt: Time.now.to_i- 3601,
        expiresIn: 3600
      })

      expect(access_token.expired?).to be true
    end

    it 'returns false if the access token is not expired' do
      access_token = Naborly::Ruby::AccessToken.new({
        access_token: token,
        createdAt: Time.now.to_i - 2300,
        expiresIn: 3600
      })

      expect(access_token.expired?).to be false
    end

    it 'returns true if the access token is not initialized with an access_token attribute' do
      access_token = Naborly::Ruby::AccessToken.new({
        createdAt: Time.now.to_i - 2300,
        expiresIn: 3600
      })

      expect(access_token.expired?).to be true
    end

    it 'returns true if the access token is not initialized with a created_at attribute' do
      access_token = Naborly::Ruby::AccessToken.new({
        access_token: token,
        expiresIn: 3600
      })

      expect(access_token.expired?).to be true
    end

    it 'returns true if the access_token is not initialized with an expires_in attribute' do
      access_token = Naborly::Ruby::AccessToken.new({
        token: token,
        createdAt: Time.now.to_i - 2300
      })

      expect(access_token.expired?).to be true
    end
  end
end
