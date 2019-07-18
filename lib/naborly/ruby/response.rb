module Naborly
  module Ruby
    class Response
      attr_reader :response, :status, :body, :headers, :request

      def initialize(http_response)
        @response = http_response
        @status = http_response.code
        @body = http_response.body
        @headers = http_response.headers
        @request = http_response.request
      end
    end
  end
end
