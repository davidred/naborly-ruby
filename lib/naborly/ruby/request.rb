module Naborly
  module Ruby
    module Request
      def request(http_method:, endpoint:, body: {}, headers: {}, basic_auth: {})
        Naborly::Ruby::Response.new(HTTParty.public_send(http_method, endpoint, body: body, headers: headers, basic_auth: basic_auth))
      end

      def auth_request(http_method:, endpoint:, body: {}, headers: {}, basic_auth: {})
        Naborly::Ruby::Response.new(HTTParty.public_send(http_method, endpoint, body: body, headers: headers, basic_auth: basic_auth))
      end
    end
  end
end
