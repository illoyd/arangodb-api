module ArangoDB
  module Test

    class Strategy

      attr_reader :client, :database_name, :collections, :graph_name, :graph_definition

      def initialize(client:, database_name: nil, collections: [], graph_name: nil, graph_definition: {})
        @client        = client
        @database_name = database_name
        @collections   = collections
        @graph_name    = graph_name
        @graph_definition = graph_definition
      end

      def before_suite
        create_database
        create_graph
        create_collections
      end

      def before_spec
      end

      def after_spec
        truncate_collections
      end

      def after_suite
        drop_graph
        drop_database
      end

      def database
        @database ||= ArangoDB::API::Database.new(client, database_name)
      end

      def graph
        @graph ||= ArangoDB::API::Graph.new(client, graph_name)
      end

      protected

      def create_database
        database.create unless database.exists?
      end

      def create_graph
        graph.create(graph_definition) if graph_name && !graph.exists?
      end

      def create_collections
        collections.each do |collection|
          client.resource('_api/collection').post('name' => collection) unless client.resource('_api/collection').get.body['names'].keys.include?(collection)
        end
      end

      def truncate_collections
        client.resource('_api/collection').get.body['names'].keys.each do |collection|
          client.resource('_api/collection', collection, 'truncate').put unless collection.start_with?('_')
        end
      end

      def drop_graph
        graph.destroy if graph_name && graph.exists?
      end

      def drop_database
        database.destroy if database.exists?
      end

    end

  end
end