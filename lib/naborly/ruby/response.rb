require 'oj'

module Naborly
  module Ruby
    class Response
      attr_reader :response, :status, :body, :parsed_body, :headers, :request

      def initialize(http_response)
        @response = http_response
        @status = http_response.code
        @body = http_response.body
        @parsed_body = http_response.parsed_response if valid_json?(http_response.body)
        @headers = http_response.headers
        @request = http_response.request
      end

      private

      def valid_json?(json)
        Oj.load(json)
        return true
      rescue Oj::ParseError => e
        return false
      end
    end
  end
end
