module Lurch
  class Client
    AUTHORIZATION = "Authorization".freeze
    REQUEST_ID = "X-Request-Id".freeze

    STATUS_EXCEPTIONS = {
      400 => Errors::BadRequest,
      401 => Errors::Unauthorized,
      403 => Errors::Forbidden,
      404 => Errors::NotFound,
      422 => Errors::UnprocessableEntity,
      500 => Errors::ServerError
    }.freeze

    def initialize(url, authorization, request_id)
      @url = url
      @authorization = authorization
      @request_id = request_id
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

  private

    attr_reader :url, :authorization, :request_id

    def catch_errors(response)
      raise STATUS_EXCEPTIONS[response.status], response.body if STATUS_EXCEPTIONS[response.status]
      raise Errors::ServerError, response.body unless (200..299).cover?(response.status)
      # TODO: handle 3xx?

      response
    end

    def client
      @client ||= Faraday.new(url: url) do |conn|
        conn.headers[AUTHORIZATION] = authorization unless authorization.empty?
        conn.headers[REQUEST_ID] = request_id unless request_id.nil?
        conn.request :jsonapi
        conn.response :jsonapi
        conn.adapter Faraday.default_adapter
      end
    end
  end
end
