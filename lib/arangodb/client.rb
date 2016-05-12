module ArangoDB
  ##
  # HTTP REST client for the ArangoDB API.
  class Client

    delegate *Faraday::Connection::METHODS, to: :connection

    def initialize(uri = nil)
      self.uri = uri
    end

    ##
    # Allow using endpoints as resources, and calling actions against them easily.
    # Returns a Resource proxy for this client.
    def resource(*paths)
      Resource.new(self, *paths)
    end

    ##
    # Short-hand for graph resource.
    # Returns a Resource proxy for the Graph (confusingly called gharial) API endpoint.
    def graph(graph_name = nil)
      resource('_api/gharial', graph_name)
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
