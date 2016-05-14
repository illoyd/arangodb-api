module ArangoDB
  module API

    ##
    # A simple object model for intereacting with Graph resources.
    class Graph

      Endpoint = '_api/gharial'.freeze

      attr_reader :client, :resource

      def initialize(client, graph_name = nil)
        @client   = client
        @graph_name = graph_name
        @resource = client.resource(Endpoint, graph_name)
      end

      def properties
        @properties ||= client.resource(Endpoint, graph_name).get.body['graph']
      end

      def graph_name
        @graph_name || properties['name']
      end

      def exists?
        self.list.include?(graph_name)
      end

      ##
      # Destroy the graph.
      # Calls POST _api/gharial
      def create(options = {})
        options['name'] = graph_name
        client.resource(Endpoint).post(options)
      end

      ##
      # Destroy the graph.
      # Calls DELETE _api/gharial/#{graph_name}
      def destroy
        client.resource(Endpoint, graph_name).delete
      end

      def list
        client.resource(Endpoint).get.body['graphs'].map { |graph| graph['_key'] }
      end

      def count
        list.count
      end

    end

  end
end