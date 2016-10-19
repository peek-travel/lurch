module Lurch
  class Client
    AUTHORIZATION = "Authorization".freeze
    REQUEST_ID = "X-Request-Id".freeze

    STATUS_EXCEPTIONS = {
      400 => Errors::BadRequest,
      401 => Errors::Unauthorized,
      403 => Errors::Forbidden,
      404 => Errors::NotFound,
      409 => Errors::Conflict,
      422 => Errors::UnprocessableEntity,
      500 => Errors::ServerError
    }.freeze

    def initialize(url, config)
      @url = url
      @config = config
    end

    def get(path)
      catch_errors(client.get(path)).body
    end

    def post(path, payload)
      catch_errors(client.post(path, payload)).body
    end

    def patch(path, payload)
      catch_errors(client.patch(path, payload)).body
    end

    def delete(path, payload = nil)
      resp = client.delete do |req|
        req.url path
        req.body = payload unless payload.nil?
      end
      catch_errors(resp).body
    end

  private

    attr_reader :url, :config

    def catch_errors(response)
      raise STATUS_EXCEPTIONS[response.status], response.body if STATUS_EXCEPTIONS[response.status]
      raise Errors::ServerError, response.body unless (200..299).cover?(response.status)

      response
    end

    def client
      @client ||= Faraday.new(url: url) do |conn|
        conn.headers[AUTHORIZATION] = authorization unless authorization.nil?
        conn.headers[REQUEST_ID] = request_id unless request_id.nil?

        conn.request :jsonapi
        conn.response :jsonapi

        conn.adapter :typhoeus
      end
    end

    def authorization
      config.authorization
    end

    def request_id
      config.request_id
    end
  end
end
