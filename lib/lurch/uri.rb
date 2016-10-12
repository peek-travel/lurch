module Lurch
  module URI
    def self.resources_uri(type, query = "")
      uri = ::URI.parse("/#{Inflecto.dasherize(type.to_s)}")
      uri.query = query unless query.empty?
      uri.to_s
    end

    def self.resource_uri(type, id, query = "")
      uri = ::URI.parse("#{Inflecto.dasherize(type.to_s)}/#{id}")
      uri.query = query unless query.empty?
      uri.to_s
    end
  end
end
