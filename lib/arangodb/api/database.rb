module ArangoDB
  module API

    ##
    # A simple object model for intereacting with Database resources.
    class Database

      Endpoint = '_api/database'.freeze
      AbsoluteEndpoint = "/#{ Endpoint }".freeze

      attr_reader :client, :resource

      def initialize(client, database_name = nil)
        @client   = client
        @database_name = database_name

        # Save a path to the database by forcing it to the root of the URI
        uri = "/_db/#{ database_name }" if database_name.present?
        @resource = @client.resource(uri, Endpoint)
      end

      def properties
        @properties ||= resource.resource('current').get.body['result']
      end

      def database_name
        @database_name || @client.uri.try(:database) || properties['name']
      end

      def system?
        !!properties['isSystem']
      end

      def exists?
        self.list.include?(database_name)
      end

      def create(options = {})
        options['name'] = database_name
        client.resource(AbsoluteEndpoint).post(options)
      end

      def destroy
        client.resource(AbsoluteEndpoint, database_name).delete
      end

      def list
        client.resource(AbsoluteEndpoint).get.body['result']
      end

      def count
        list.count
      end

    end

  end
end