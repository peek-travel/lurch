module Lurch
  class Relationship
    attr_reader :data

    def self.from_document(store, relationship_key, document)
      return Relationship::HasMany.new(store, relationship_key, document) if document.key?("data") && document["data"].is_a?(Array)
      return Relationship::HasOne.new(store, relationship_key, document) if document.key?("data")
      return Relationship::Linked.new(store, relationship_key, document) if document.key?("links") && document["links"].key?("related")
      raise ArgumentError, "Invalid relationship document"
    end

    def loaded?
      !!defined?(@data)
    end

    def inflector
      @store.inflector
    end

    def respond_to_missing?(method, all)
      raise Errors::RelationshipNotLoaded, @relationship_key unless loaded?
      super
    end

    def method_missing(method, *arguments, &block)
      raise Errors::RelationshipNotLoaded, @relationship_key unless loaded?
      super
    end
  end
end
