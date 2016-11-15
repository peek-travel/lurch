module Lurch
  class StoredResource
    def initialize(store, resource_object)
      @store = store
      @resource_object = resource_object
    end

    def id
      @id ||= @resource_object["id"]
    end

    def type
      @type ||= Inflector.decode_type(@resource_object["type"])
    end

    def attributes
      fixed_attributes
    end

    def relationships
      fixed_relationships
    end

    def attribute?(name)
      fixed_attributes.key?(name.to_sym)
    end

    def attribute(name)
      fixed_attributes[name.to_sym]
    end

    def relationship?(name)
      fixed_relationships.key?(name.to_sym)
    end

    def relationship(name)
      fixed_relationships[name.to_sym]
    end

  private

    def fixed_attributes
      @fixed_attributes ||= resource_attributes.each_with_object({}) do |(key, value), hash|
        hash[Inflector.decode_key(key)] = value
      end
    end

    def fixed_relationships
      @fixed_relationships ||= resource_relationships.each_with_object({}) do |(key, value), hash|
        relationship_key = Inflector.decode_key(key)
        hash[relationship_key] = Relationship.from_document(@store, relationship_key, value)
      end
    end

    def resource_attributes
      @resource_object["attributes"] || {}
    end

    def resource_relationships
      @resource_object["relationships"] || []
    end
  end
end
