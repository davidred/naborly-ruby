require 'pry'

module Naborly
  module Ruby
    module Request
      HOST = ENV['NABORLY_HOST'] || 'https://sandbox.api.naborly.com'.freeze

      def request(http_method:, path:, body: {}, headers: {})
        authenticate!
        @last_response = Naborly::Ruby::Response.new(HTTParty.public_send(http_method, "#{HOST}#{path}", body: body, headers: auth_header))

        return last_response if response_successful?

        raise error_class, error_message
      end

      def auth_request(http_method:, endpoint:, body: {}, headers: {}, basic_auth: {})
        @last_response = Naborly::Ruby::Response.new(HTTParty.public_send(http_method, endpoint, body: body, headers: headers, basic_auth: basic_auth))

        return last_response if response_successful?
        raise error_class, error_message
      end

      private

      def error_message
        msg = "Code: #{last_response.status}"

        if last_response&.parsed_body
          msg += ", message: #{last_response.parsed_body['message']}" if last_response&.parsed_body && last_response&.parsed_body.is_a?(Hash)
        elsif last_response.body && !last_response.body.empty?
          msg += ", message: #{last_response.body}"
        end

        msg
      end

      def error_class
        case last_response.status
        when Naborly::Ruby::HTTP_BAD_REQUEST_CODE
          Naborly::Ruby::BadRequestError
        when Naborly::Ruby::HTTP_UNAUTHORIZED_CODE
          Naborly::Ruby::UnauthenticatedError
        when Naborly::Ruby::HTTP_FORBIDDEN_CODE
          Naborly::Ruby::ForbiddenError
        when Naborly::Ruby::HTTP_NOT_FOUND_CODE
          Naborly::Ruby::NotFoundError
        when Naborly::Ruby::HTTP_NOT_ACCEPTABLE_CODE
          Naborly::Ruby::NotAcceptableError
        when Naborly::Ruby::HTTP_CONFLICT_CODE
          Naborly::Ruby::ConflictError
        when Naborly::Ruby::HTTP_EXPECTATION_FAILED_CODE
          Naborly::Ruby::ConflictError
        when Naborly::Ruby::HTTP_INTERNAL_SERVER_ERROR_CODE
          Naborly::Ruby::InternalServerError
        when Naborly::Ruby::HTTP_BAD_GATEWAY_CODE
          Naborly::Ruby::BadGatewayError
        else
          Naborly::Ruby::UnknownError
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
