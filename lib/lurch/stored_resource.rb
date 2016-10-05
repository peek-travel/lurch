module Lurch
  class StoredResource
    def initialize(store, data)
      @store = store
      @data = data
    end

    def id
      @id ||= data.id
    end

    def type
      @type ||= Lurch.normalize_type(data.type)
    end

    def attributes
      fixed_attributes
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

    attr_reader :store, :data

    def fixed_attributes
      @fixed_attributes ||= data.attributes.to_h.each_with_object({}) do |(key, value), hash|
        hash[Inflecto.underscore(key).to_sym] = value
      end
    end

    def fixed_relationships
      @fixed_relationships ||= data.relationships.to_h.each_with_object({}) do |(key, value), hash|
        hash[Inflecto.underscore(key).to_sym] = Relationship.new(store, value)
      end
    end
  end
end
