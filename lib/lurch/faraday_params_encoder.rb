# frozen_string_literal: true

module Lurch
  class FaradayParamsEncoder
    def self.encode(params)
      QueryBuilder.new(params).encode
    end

    def self.decode(query)
      Rack::Utils.parse_nested_query(query)
    end
  end
end
