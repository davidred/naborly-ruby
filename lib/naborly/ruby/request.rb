module Naborly
  module Ruby
    module Request
      def request(http_method:, endpoint:, body: {}, headers: {})
        authenticate!
        @last_response = Naborly::Ruby::Response.new(HTTParty.public_send(http_method, endpoint, body: body.to_json, headers: auth_header))

        return last_response if response_successful?
        raise error_class, "Code: #{last_response.status}, body: #{last_response.body}"
      end

      def auth_request(http_method:, endpoint:, body: {}, headers: {}, basic_auth: {})
        @last_response = Naborly::Ruby::Response.new(HTTParty.public_send(http_method, endpoint, body: body, headers: headers, basic_auth: basic_auth))

        return last_response if response_successful?
        raise error_class, "Code: #{last_response.status}, body: #{last_response.body}"
      end

      private

      def error_class
        case last_response.status
        when Naborly::Ruby::HTTP_BAD_REQUEST_CODE
          Naborly::Ruby::BadRequestError
        when Naborly::Ruby::HTTP_UNAUTHORIZED_CODE
          Naborly::Ruby::UnauthenticatedError
        when Naborly::Ruby::HTTP_CONFLICT_CODE
          Naborly::Ruby::ConflictError
        end
      end

      def response_successful?
        [Naborly::Ruby::HTTP_OK_CODE, Naborly::Ruby::HTTP_CREATED_CODE].include?(last_response.status)
      end

      def auth_header
        { "Authorization" => "Bearer #{access_token&.token}" }
      end
    end
  end
end
