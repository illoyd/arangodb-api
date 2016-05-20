module ArangoDB
  module API

    ##
    # Collection result, wrapping the output of a collection-based query in a smart way.
    # Converts the results of a query into documents/vertices/edges as appropriate.
    class CollectionResult
      include Enumerable

      attr_reader :key, :client

      def initialize(result_document, client: nil, key: 'result')
        @current_result_document = result_document
        @original_results = @current_result_document[key]
        @key = key
        @client = client
      end

      def empty?
        load_next_batch while @original_results.empty? && more?
        @original_results.empty?
      end

      def load_all
        load_next_batch while more?
      end

      def count_all
        load_all
        @original_results.count
      end

      def count
        @current_result_document.try(:fetch, 'count'.freeze) || count_all
      end

      def [](index)
        load_next_batch while @original_results[index].nil? && more?
        @original_results[index]
      end

      def cursor
        client.resource('_api/cursor'.freeze, cursor_id)
      end

      def more?
        @current_result_document['hasMore'.freeze]
      end

      def cursor_id
        @current_result_document['id'.freeze]
      end

      def load_next_batch
        @current_result_document = cursor.put.body
        @original_results.concat(@current_result_document[key])
      end

      def each
        enum_for(:each) unless block_given?

        index = 0
        until self[index].nil?
          yield self[index]
          index += 1
        end
      end

    end

  end # API
end # ArangoDB