module Lurch
  class StoredResource
    def initialize(store, resource_object)
      @store = store
      @resource_object = resource_object
    end

    def id
      @id ||= resource_object["id"]
    end

    def type
      @type ||= Lurch.normalize_type(resource_object["type"])
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

    attr_reader :store, :resource_object

    def fixed_attributes
      @fixed_attributes ||= resource_object["attributes"].each_with_object({}) do |(key, value), hash|
        hash[Inflecto.underscore(key).to_sym] = value
      end
    end

    def fixed_relationships
      @fixed_relationships ||= resource_object["relationships"].each_with_object({}) do |(key, value), hash|
        hash[Inflecto.underscore(key).to_sym] = Relationship.new(store, value)
      end
    end
  end
end
