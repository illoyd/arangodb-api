module ArangoDB
  module OGM
    module API

      ##
      # A simple object model for intereacting with Database resources.
      class Database

        attr_reader :client, :resource

        def initialize(client, database_name = nil)
          @database_name = database_name
          uri = "/_db/#{ database_name }" if database_name.present?

          @client = client
          @resource = client.resource(uri)
        end

        def properties
          @properties ||= resource.current
        end

        def database_name
          @database_name || properties['name']
        end

        def system?
          !!properties['isSystem']
        end

        def exists?
          client.resource('/_api/database').get.body['results'].include?(database_name)
        end

        def create(options = {})
        end

        def destroy
          client.resource('/_api/database')
        end

        protected

        def system_database
          client.resource('/')
        end

        def api_resource
          resource.resource('_api/database')
        end

        def instance_resource
          api_resource.resource(database_name)
        end

      end

    end
  end
end