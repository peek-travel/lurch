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
        env[:body] = JSON.generate(env[:body]) if env[:body].is_a?(Hash)
        @app.call(env)
      end
    end
  end
end

Faraday::Request.register_middleware jsonapi: -> { Lurch::Middleware::JSONApiRequest }
