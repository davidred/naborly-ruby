require "naborly/ruby/version"
require 'naborly/ruby/client'
require 'naborly/ruby/access_token'

module Naborly
  module Ruby
    class Error < StandardError; end
    # Your code goes here...

    class UnauthenticatedError < StandardError; end
  end
end
