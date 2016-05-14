module ArangoDB
  module API

    ##
    # A basic object to ease access to the common fields of an ArangoDB response.
    class Response

      attr_reader :client, :response

      delegate :body, to: :response
      delegate :[], to: :body

      def initialize(client: nil, response: nil)
        @client   = client
        @response = response
      end

      def ==(other)
        body == other.body
      end

    end

    ##
    # An Error response.
    class ErrorResponse < Response
      def code
        body['code']
      end

      def message
        body['errorMessage']
      end

      def number
        body['errorNum'.freeze]
      end

      def self.===(other)
        (other.try(:body) || other)['error'] == true
      end

    end

    ##
    # A response from a cursor-like query, such as from AQL or the Simple
    # queries. Also provides functionality for iterating over the response
    # objects.
    class CursorResponse < Response
      include Enumerable

      delegate :each, :empty?, to: :result

      def more?
        body['hasMore']
      end

      def id
        body['id']
      end

      def count
        body['count']
      end

      def result
        @cached_results ||= [].tap do |cr|
          cr.concat(body['result'])
          while more?
            @response = more
            cr.concat(body['result'])
          end
        end
      end

      def more
        if more?
          self.class.new(client: client, response: client.resource('_api/cursor', id).put)
        else
          raise RuntimeError, 'no more items in cursor!'
        end
      end

      def self.===(other)
        (other.try(:body) || other).has_key?('result')
      end

    end

  end
end