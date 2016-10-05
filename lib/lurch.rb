require "inflecto"
require "faraday"

require "lurch/middleware/json_api_request"
require "lurch/middleware/json_api_response"

require "lurch/errors/json_api_error"
require "lurch/errors/bad_request"
require "lurch/errors/unauthorized"
require "lurch/errors/forbidden"
require "lurch/errors/not_found"
require "lurch/errors/server_error"
require "lurch/errors/relationship_not_loaded"

require "lurch/stored_resource"
require "lurch/relationship"
require "lurch/resource"

require "lurch/changeset"
require "lurch/client"
require "lurch/store"

module Lurch
  def self.normalize_type(type)
    Inflecto.pluralize(Inflecto.underscore(type)).to_sym
  end
end
