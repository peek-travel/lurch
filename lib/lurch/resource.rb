module Lurch
  class Resource
    attr_reader :id

    def initialize(store, resource_identifier)
      @store = store
      @type = Lurch.normalize_type(resource_identifier.type)
      @id = resource_identifier.id
    end

    def loaded?
      !!_stored_resource
    end

    def fetch
      @store.find(@type, id)
    end

    def attributes
      raise Errors::RelationshipNotLoaded unless loaded?

      _stored_resource.attributes
    end

  private

    def _stored_resource
      @store.fetch(@type, id)
    end

    def respond_to_missing?(method, all)
      return super unless loaded?
      _stored_resource.attribute?(method) || _stored_resource.relationship?(method) || super
    end

    def method_missing(method, *arguments, &block)
      raise Errors::RelationshipNotLoaded unless loaded?

      return _stored_resource.attribute(method) if _stored_resource.attribute?(method)
      return _stored_resource.relationship(method) if _stored_resource.relationship?(method)

      super
    end
  end
end
