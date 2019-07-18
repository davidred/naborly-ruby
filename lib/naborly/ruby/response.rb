module Naborly
  module Ruby
    class Response
      attr_reader :response, :status, :body, :headers

      def initialize(http_response)
        @response = response
        @status = http_response.code
        @body = http_response.body
        @headers = http_response.headers
      end
    end
  end
end
