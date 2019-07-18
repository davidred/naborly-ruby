require 'active_support/hash_with_indifferent_access'

module Naborly
  module Ruby
    class AccessToken
      attr_reader :token, :created_at, :expires_in, :token_type, :options

      def initialize(options = {})
        @options = ActiveSupport::HashWithIndifferentAccess.new(options)
        @token = @options[:access_token]
        @created_at = @options[:createdAt]
        @expires_in = @options[:expiresIn]
        @token_type = @options[:token_type]
      end

      def expired?
        return true unless token && created_at && expires_in
        Time.now > expires_at
      end

      def expires_at
        Time.at(created_at + expires_in)
      end
    end
  end
end
