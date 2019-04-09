module Lurch
  class Resource
    attr_reader :id, :type

    def initialize(store, type, id)
      @store = store
      @type = Inflector.decode_type(type)
      @id = id
    end

    def loaded?
      !!resource_from_store
    end

    def fetch
      @store.from(type).find(id)
      self
    end

    def attributes
      raise Errors::ResourceNotLoaded, resource_class_name unless loaded?

      resource_from_store.attributes
    end

    def relationships
      raise Errors::ResourceNotLoaded, resource_class_name unless loaded?

      resource_from_store.relationships
    end

    def ==(other)
      eql?(other)
    end

    def eql?(other)
      id == other.id && type == other.type
    end

    def [](attribute)
      raise Errors::ResourceNotLoaded, resource_class_name unless loaded?

      resource_from_store.attribute(attribute)
    end

    def resource_class_name
      Inflector.classify(type)
    end

    def inspect
      inspection = if loaded?
                     attributes.map { |name, value| "#{name}: #{value.inspect}" }.join(", ")
                   else
                     "not loaded"
                   end
      "#<#{self.class}[#{type}] id: #{id.inspect}, #{inspection}>"
    end

  private

    def resource_from_store
      @store.resource_from_store(type, id)
    end

    def respond_to_missing?(method, all)
      return super unless loaded?
      resource_from_store.attribute?(method) || resource_from_store.relationship?(method) || super
    end

    def method_missing(method, *arguments, &block)
      raise Errors::ResourceNotLoaded, resource_class_name unless loaded?

      return resource_from_store.attribute(method) if resource_from_store.attribute?(method)
      if resource_from_store.relationship?(method)
        rel = resource_from_store.relationship(method)
        return rel.loaded? ? rel.data : rel
      end

      super
    end
  end
end
