module Lurch
  module Middleware
    class JSONApiResponse < Faraday::Middleware
      MIME_TYPE = "application/vnd.api+json".freeze

      dependency do
        require "jsonapi" unless defined?(::JSONAPI)
      end

      def call(conn)
        @app.call(conn).on_complete do |env|
          env[:body_raw] = env[:body]
          begin
            env[:body] = JSONAPI.parse(env[:body])
          rescue StandardError => err
            env[:parse_error] = err
          end
        end
      end
    end
  end
end

Faraday::Response.register_middleware jsonapi: -> { Lurch::Middleware::JSONApiResponse }
