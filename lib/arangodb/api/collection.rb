module ArangoDB
  module API

    ##
    # A simple object model for intereacting with Graph resources.
    class Collection

      Document = 2
      Edge = 3

      Endpoint = '_api/collection'.freeze

      attr_reader :client

      def initialize(client, collection_name = nil)
        @client   = client
        @collection_name = collection_name
        @resource = client.resource(Endpoint, collection_name)
      end

      def properties
        @properties ||= client.resource(Endpoint, collection_name).get.body
      end

      def collection_name
        @collection_name || properties['name']
      end

      def system?
        !!properties['isSystem'.freeze]
      end

      def type
        properties['type']
      end

      def document?
        type == Document
      end

      def edge?
        type == Edge
      end

      def exists?
        self.list.include?(collection_name)
      end

      ##
      # Destroy the graph.
      # Calls POST _api/gharial
      def create(options = {})
        options['name'] = collection_name
        client.resource(Endpoint).post(options)
      end

      ##
      # Destroy the graph.
      # Calls DELETE _api/gharial/#{collection_name}
      def destroy
        client.resource(Endpoint, collection_name).delete
      end

      def truncate
        client.resource(Endpoint, collection_name, 'truncate'.freeze).put
      end

      def list
        client.resource(Endpoint).get.body['names'].keys
      end

      def count
        list.count
      end

    end

  end
end