module ArangoDB
  module Middleware
    class CustomError < Faraday::Response::Middleware
      ClientErrorStatuses = 400...600

      def on_complete(env)
        case env[:status]

        when 404
          raise ArangoDB::API::ResourceNotFound, env

        when 407
          raise Faraday::Error::ConnectionFailed, %{407 "Proxy Authentication Required "}

        when 409 # Conflict
          raise_409(env)

        when ClientErrorStatuses
          raise ArangoDB::API::ResponseError, env
        end
      end

      def raise_409(env)
        case env[:body]['errorNum']
        when 1207
          raise ArangoDB::API::DuplicateResourceName, env
        else
          raise ArangoDB::API::ResponseError, env
        end
      end

    end
  end
end
