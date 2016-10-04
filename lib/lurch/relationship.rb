module Lurch
  class Relationship
    include Enumerable

    def initialize(store, document)
      @document = document
      @store = store
      create_resources(document.data) unless document.data.nil?
    end

    def loaded?
      one? || many?
    end

    def resource_loaded?
      if one?
        @resource.loaded?
      elsif many?
        @resources.all?(&:loaded?)
      else
        false
      end
    end

    def link?
      @document.links.respond_to?(:related)
    end

    def one?
      !@resource.nil?
    end

    def many?
      !@resources.nil?
    end

    def each(&block)
      if one?
        Array(@resource).each(&block)
      elsif many?
        @resources.each(&block)
      else
        raise Errors::RelationshipNotLoaded
      end
    end

    def fetch
      if link?
        result = @store.load_from_url(@document.links.related.value)
        set_resources(result.is_a?(Array), Array(result))
      elsif one?
        @resource.fetch
      elsif many?
        @resources.map(&:fetch)
      end

      self
    end

  private

    def create_resources(data)
      resources = Array(data).map do |resource|
        Resource.new(@store, resource)
      end

      set_resources(data.is_a?(Array), resources)
    end

    def set_resources(many, resources)
      if many
        @resources = resources
      else
        @resource = resources.first
      end
    end

    def respond_to_missing?(method, all)
      return super unless one?
      @resource.respond_to?(method, all) || super
    end

    def method_missing(method, *arguments, &block)
      return super unless one?
      return @resource.send(method, *arguments, &block) if @resource.respond_to?(method)
      raise Errors::RelationshipNotLoaded if one? && !@resource.loaded?
      super
    end
  end
end
