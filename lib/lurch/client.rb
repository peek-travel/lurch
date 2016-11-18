module Lurch
  class Client
    AUTHORIZATION = "Authorization".freeze

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
      response = timed_request("GET", path) { client.get(path) }
      catch_errors(response).body
    end

    def post(path, payload)
      response = timed_request("POST", path, payload) { client.post(path, payload) }
      # TODO: if 204 is returned, use payload as return body (http://jsonapi.org/format/#crud-creating-responses-204)
      catch_errors(response).body
    end

    def patch(path, payload)
      response = timed_request("PATCH", path, payload) { client.patch(path, payload) }
      catch_errors(response).body
    end

    def delete(path, payload = nil)
      response = timed_request("DELETE", path, payload) do
        client.delete do |req|
          req.url path
          req.body = payload unless payload.nil?
        end
      end
      catch_errors(response).body
    end

  private

    attr_reader :url, :config

    def timed_request(method, path, payload = nil)
      log_request(method, path, payload)
      start_time = Time.now.to_f
      response = yield
      end_time = Time.now.to_f
      time_in_ms = ((end_time - start_time) * 1000).to_i
      log_response(response, time_in_ms)
      response
    end

    def log_request(method, path, payload)
      Logger.debug { "-> #{method} #{path}" }
      Logger.debug { "-> #{payload}" } if payload && Lurch.configuration.log_payloads
    end

    def log_response(response, time_in_ms)
      Logger.debug { "<- #{response.status} in #{time_in_ms}ms" }
      Logger.debug { "<- #{response.body}" } if Lurch.configuration.log_payloads
    end

    def catch_errors(response)
      raise STATUS_EXCEPTIONS[response.status], response.body if STATUS_EXCEPTIONS[response.status]
      raise Errors::ServerError, response.body unless (200..299).cover?(response.status)

      response
    end

    def client
      @client ||= Faraday.new(url: url) do |conn|
        conn.headers[AUTHORIZATION] = authorization unless authorization.nil?

        conn.request :jsonapi
        conn.response :jsonapi

        conn.adapter :typhoeus
      end
    end

    def authorization
      config.authorization
    end
  end
end
