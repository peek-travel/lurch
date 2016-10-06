module Lurch
  class Resource
    attr_reader :id, :type

    def initialize(store, type, id)
      @store = store
      @type = Lurch.normalize_type(type)
      @id = id
    end

    def loaded?
      !!resource_from_store
    end

    def fetch
      @store.find(@type, id)
      self
    end

    def attributes
      raise Errors::ResourceNotLoaded unless loaded?

      resource_from_store.attributes
    end

    def relationships
      raise Errors::ResourceNotLoaded unless loaded?

      resource_from_store.relationships
    end

    def ==(other)
      eql?(other)
    end

    def eql?(other)
      id == other.id && type == other.type
    end

    def [](attribute)
      raise Errors::ResourceNotLoaded unless loaded?

      resource_from_store.attributes[attribute]
    end

  private

    def resource_from_store
      @store.resource_from_store(@type, id)
    end

    def respond_to_missing?(method, all)
      return super unless loaded?
      resource_from_store.attribute?(method) || resource_from_store.relationship?(method) || super
    end

    def method_missing(method, *arguments, &block)
      raise Errors::ResourceNotLoaded unless loaded?

      return resource_from_store.attribute(method) if resource_from_store.attribute?(method)
      return resource_from_store.relationship(method) if resource_from_store.relationship?(method)

      super
    end
  end
end
