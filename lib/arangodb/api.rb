require "arangodb/api/version"

# Include specific ActiveSupport items
require 'active_support/core_ext/object/blank'
require 'active_support/core_ext/object/try'
require 'active_support/core_ext/string/inflections'
require 'active_support/core_ext/module/delegation'

# Require libraries
require 'net/http/persistent'
require 'faraday'
require 'faraday_middleware'
require 'oj'

module ArangoDB
  module API
    # Your code goes here...

    class Error < StandardError
      attr_reader :original
      def initialize(msg, orig = $!)
        super(msg)
        @original = orig
      end
    end

    class ResponseError < Error
      attr_reader :response
      def initialize(response, orig = $!)
        msg = {:status => response.status, :headers => response.response_headers, :body => response.body}
        super(msg, orig)
        @response = response
      end
    end

    class ResourceNotFound < ResponseError; end
    class DuplicateResourceName < ResponseError; end

  end
end

# Require URI files
require "uri/arangodb"

# Require middleware
require 'arangodb/middleware/custom_error'

# Require ArangoDB files
%w( client resource document_handle ).each { |file| require "arangodb/#{ file }" }

# Require additional API files
%w( database graph collection collection_result ).each { |file| require "arangodb/api/#{ file }" }

# Require testing files
%w( strategy ).each { |file| require "arangodb/test/#{ file }" }