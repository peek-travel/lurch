module Lurch
  class URIBuilder
    def initialize(inflector)
      @inflector = inflector
    end

    def resources_uri(type, query = "")
      resource = inflector.encode_type(type)
      uri = ::URI.parse("/#{resource}")
      uri.query = query unless query.empty?
      uri.to_s
    end

    def resource_uri(type, id, query = "")
      resource = inflector.encode_type(type)
      uri = ::URI.parse("#{resource}/#{id}")
      uri.query = query unless query.empty?
      uri.to_s
    end

    def relationship_uri(type, id, relationship_key)
      resource = inflector.encode_type(type)
      relationship = inflector.encode_key(relationship_key)
      uri = ::URI.parse("#{resource}/#{id}/relationships/#{relationship}")
      uri.to_s
    end

  private

    attr_reader :inflector
  end
end
