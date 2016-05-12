module URI
  ##
  # Pseudo-ArangoDB URI handler
  class ArangoDB < ::URI::Generic
    DEFAULT_PORT = 8529

    def database
      path.try(:[], 0) == '/' ? path[1..-1] : path
    end

    def database=(value)
      if value.present?
        self.path = value[0] != '/' ? '/' + value : value
      else
        self.path = nil
      end
    end

    def to_http_uri
      parts = {
        host: host,
        port: port,
        path: database_path,
        userinfo: userinfo
      }
      URI::HTTP.build(parts)
    end

    delegate :request_uri, to: :to_http_uri

    protected

    def database_path
      "/_db/#{ database }" if database.present?
    end

  end

  @@schemes['ARANGODB'] = ArangoDB

end