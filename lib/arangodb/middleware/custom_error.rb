module ArangoDB
  module Middleware
    class CustomError < Faraday::Response::Middleware

        def call(env)
          begin
            @app.call(env)
          rescue Faraday::ResourceNotFound => e
            raise ArangoDB::API::ResourceNotFound.new(env, e)
          rescue Faraday::ClientError => e
            raise ArangoDB::API::ResponseError.new(env, e)
          end
        end

      end
  end
end