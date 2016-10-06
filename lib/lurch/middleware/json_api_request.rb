module Lurch
  module Middleware
    class JSONApiRequest < Faraday::Middleware
      CONTENT_TYPE = "Content-Type".freeze
      ACCEPT = "Accept".freeze
      MIME_TYPE = "application/vnd.api+json".freeze

      dependency do
        require "json" unless defined?(::JSON)
      end

      def call(env)
        env[:request_headers][CONTENT_TYPE] = MIME_TYPE
        env[:request_headers][ACCEPT] = MIME_TYPE
        env[:body] = JSON.generate(env[:body]) if jsonable?(env)
        @app.call(env)
      end

    private

      def jsonable?(env)
        case env[:body]
        when Hash
          true
        when Array
          true
        else
          false
        end
      end
    end
  end
end

Faraday::Request.register_middleware jsonapi: -> { Lurch::Middleware::JSONApiRequest }
