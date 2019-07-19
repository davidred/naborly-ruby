require 'httparty'
require 'oj'
require 'naborly/ruby/request'
require 'naborly/ruby/response'
require 'naborly/ruby/access_token'
require 'naborly/ruby/client/api_subusers'
require 'naborly/ruby/client/rental_applications'
# require 'naborly/ruby/client'

module Naborly
  module Ruby
    class Client
      include Naborly::Ruby::Request
      include Naborly::Ruby::Client::ApiSubusers
      include Naborly::Ruby::Client::RentalApplications

      attr_reader :client_id, :client_secret, :access_token, :last_response

      AUTH_URL = 'https://auth.api.naborly.com/v1/auth'.freeze
      AUTH_BODY = { grant_type: 'client_credentials' }.freeze
      AUTH_HEADERS = { 'Content-Type' => 'application/x-www-form-urlencoded', 'Host' => 'auth.api.naborly.com' }.freeze

      CLIENT_ID = 'yxEcjm24RjxPQc44PNb8UDdIiVsgFS4k'.freeze
      CLIENT_SECRET = 'GWjqF7m2ZCpbBrowPKK3j3chIe1cixmH'.freeze

      def initialize(options = {})
        @client_id = options[:client_id] || CLIENT_ID
        @client_secret = options[:client_secret] || CLIENT_SECRET
      end

      def authenticate!
        return access_token if authenticated?

        res = auth_request(
          http_method: :post,
          endpoint: AUTH_URL,
          body: AUTH_BODY,
          headers: AUTH_HEADERS,
          basic_auth: { username: client_id, password: client_secret }
        )

        @access_token = Naborly::Ruby::AccessToken.new(Oj.load(res.body))
      end

      def attributes
        Hash[instance_variables.map { |name| [name, instance_variable_get(name)] }]
      end

      def get(endpoint:)
        authenticated_request!(http_method: :get, endpoint: endpoint)
      end

      def post(endpoint:, body: {})
        authenticated_request!(http_method: :post, endpoing: endpoint, body: body)
      end

      def authenticated_request!(http_method:, endpoint:, body: {}, headers: {}, basic_auth: {})
        authenticate! unless authenticated?
        request(http_method: http_method, endpoint: endpoint, body: body, headers: headers, basic_auth: basic_auth)
      end

      private

      def authenticated?
        !access_token.nil? && access_token.expired?
      end
    end
  end
end
