require "naborly/ruby/version"
require 'naborly/ruby/client'

module Naborly
  module Ruby
    class Error < StandardError; end
    # Your code goes here...

    class UnauthenticatedError < StandardError; end
    class BadRequestError < StandardError; end
    class NotFoundError < StandardError; end
    class NotAcceptableError < StandardError; end
    class ConflictError < StandardError; end
    class ExpectationFailedError < StandardError; end

    class InternalServerError < StandardError; end
    class BadGatewayError < StandardError; end

    class UnknownError < StandardError; end

    HTTP_OK_CODE = 200
    HTTP_CREATED_CODE = 201

    HTTP_BAD_REQUEST_CODE = 400
    HTTP_UNAUTHORIZED_CODE = 401
    HTTP_NOT_FOUND_CODE = 404
    HTTP_NOT_ACCEPTABLE_CODE = 406
    HTTP_CONFLICT_CODE = 409
    HTTP_EXPECTATION_FAILED_CODE = 417

    HTTP_INTERNAL_SERVER_ERROR_CODE = 500
    HTTP_BAD_GATEWAY_CODE = 502
  end
end
