# frozen_string_literal: true

module Lurch
  module Middleware
    class JSONApiResponse < Faraday::Middleware
      MIME_TYPE = "application/vnd.api+json"

      dependency do
        require "json" unless defined?(::JSON)
      end

      def call(conn)
        @app.call(conn).on_complete do |env|
          env[:body_raw] = env[:body]
          begin
            env[:body] = JSON.parse(env[:body])
          rescue StandardError => e
            env[:parse_error] = e
          end
        end
      end
    end
  end
end

Faraday::Response.register_middleware jsonapi: -> { Lurch::Middleware::JSONApiResponse }
