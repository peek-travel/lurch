require "uri"

require "inflecto"
require "faraday"
require "typhoeus"
require "typhoeus/adapters/faraday"

require "lurch/middleware/json_api_request"
require "lurch/middleware/json_api_response"

require "lurch/errors/json_api_error"
require "lurch/errors/bad_request"
require "lurch/errors/unauthorized"
require "lurch/errors/forbidden"
require "lurch/errors/not_found"
require "lurch/errors/unprocessable_entity"
require "lurch/errors/server_error"
require "lurch/errors/not_loaded"
require "lurch/errors/relationship_not_loaded"
require "lurch/errors/resource_not_loaded"

require "lurch/stored_resource"
require "lurch/relationship"
require "lurch/resource"

require "lurch/uri"
require "lurch/query_builder"
require "lurch/payload_builder"
require "lurch/query"
require "lurch/changeset"
require "lurch/client"
require "lurch/store"

module Lurch
  def self.normalize_type(type)
    Inflecto.pluralize(Inflecto.underscore(type)).to_sym
  end

  def self.to_a(value)
    return [] if value.nil?
    value.is_a?(Array) ? value : [value]
  end
end
