require "naborly/ruby/version"
require 'naborly/ruby/client'
require 'naborly/ruby/client/api_subusers'
require 'naborly/ruby/access_token'

module Naborly
  module Ruby
    class Error < StandardError; end
    # Your code goes here...

    class UnauthenticatedError < StandardError; end
    class BadRequestError < StandardError; end
    class ConflictError < StandardError; end

    HTTP_OK_CODE = 200

    HTTP_BAD_REQUEST_CODE = 400
    HTTP_UNAUTHORIZED_CODE = 401
    HTTP_CONFLICT_CODE = 409
  end
end
