module Naborly
  module Ruby
    module Request
      def request(http_method:, endpoint:, body: {}, headers: {})
        authenticate!
        @last_response = Naborly::Ruby::Response.new(HTTParty.public_send(http_method, endpoint, body: body.to_json, headers: auth_header))
      end

      def auth_request(http_method:, endpoint:, body: {}, headers: {}, basic_auth: {})
        @last_response = Naborly::Ruby::Response.new(HTTParty.public_send(http_method, endpoint, body: body, headers: headers, basic_auth: basic_auth))
      end

      private

      def auth_header
        { "Authorization" => "Bearer #{access_token&.token}" }
      end
    end
  end
end
