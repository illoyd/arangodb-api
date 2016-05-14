module ArangoDB
  ##
  # HTTP REST client for the ArangoDB API.
  class Client

    # delegate *Faraday::Connection::METHODS, to: :connection

    def initialize(uri = nil)
      self.uri = uri
    end

    %w[get head delete].each do |method|
      class_eval <<-RUBY, __FILE__, __LINE__ + 1
        def #{method}(url = nil, params = nil, headers = nil)
          process_response(connection.#{method}(url, params, headers))
        end
      RUBY
    end

    %w[post put patch].each do |method|
      class_eval <<-RUBY, __FILE__, __LINE__ + 1
        def #{method}(url = nil, body = nil, headers = nil, &block)
          process_response(connection.#{method}(url, body, headers, &block))
        end
      RUBY
    end

    def process_response(response)
      case response
      when API::ErrorResponse
        API::ErrorResponse.new(response: response)
      when API::CursorResponse
        API::CursorResponse.new(client: self, response: response)
      else
        API::Response.new(response: response)
      end
    end

    ##
    # Allow using endpoints as resources, and calling actions against them easily.
    # Returns a Resource proxy for this client.
    def resource(*paths)
      Resource.new(self, *paths)
    end

    ##
    # Build a new Database resource linked to this client.
    def database(database_name = nil)
      API::Database.new(self, database_name)
    end

    ##
    # Build a new Graph resource linked to this client.
    def graph(graph_name = nil)
      API::Graph.new(self, graph_name)
    end

    ##
    # Return the current URI or default URI.
    def uri
      @uri ||= self.class.default_uri
    end

    def uri=(value)
      @uri = case value
      when String
        URI(value)
      else
        value
      end
    end

    def self.default_url
      ENV[ ENV['ARANGODB_PROVIDER'].presence || 'ARANGODB_URI' ]
    end

    def self.default_uri
      url = self.default_url
      URI(url) if url.present?
    end

    def connection_uri
      uri.try(:to_http_uri) || uri
    end

    def connection
      @connection ||= Faraday.new(connection_uri) do |faraday|
        # Customise errors
        faraday.use ArangoDB::Middleware::CustomError

        # Pack JSON requests
        faraday.request :json

        # Unpack JSON responses
        faraday.response :json, :content_type => /\bjson$/

        # Use persistent HTTP connections
        faraday.adapter :net_http_persistent
      end
    end

    ##
    # Test if the connection is present. Assumes the connection is valid if still assigned.
    def connected?
      @connection.present?
    end

    ##
    # Shutdown and remove the internal connection
    def disconnect!
      @connection.shutdown if connected?
      @connection = nil
    end

  end # Client
end # ArangoDB
