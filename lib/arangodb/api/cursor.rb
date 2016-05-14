module ArangoDB
  module OGM
    module API

      class Cursor
        attr_reader :client

        def initialize(client)
          @client = client
        end

        def cursor(**options)
          @response = CursorResponse.new(client.resource('_api/cursor').post(**options))
          collect_results
        end

        alias :query :cursor

        def simple(*paths, **options)
          @response = CursorResponse.new(client.resource('_api/simple', *paths).put(**options))
          collect_results
        end

        def collect_results
          results = []
          begin
            results.append(@response.result)
            next
          end unless @response.more?
        end

        def next
          if more?
            @response = CursorResponse.new(client.resource('_api/cursor', id).put)
            self
          else
            raise RuntimeError, 'no more items in cursor!'
          end
        end

      end

      ##
      # A helper method for processing cursor-based queries.
      class CursorResponse

        attr_reader :response

        delegate :body, to: :response

        def initialize(response)
          @response = response
        end

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
          body['result']
        end

      end

    end
  end
end