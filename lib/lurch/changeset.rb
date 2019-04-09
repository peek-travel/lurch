# frozen_string_literal: true

module Lurch
  class Changeset
    attr_reader :id, :type
    attr_accessor :attributes, :relationships, :errors

    def initialize(type, attributes = {})
      is_resource = type.is_a?(Resource)
      @type = is_resource ? type.type : Inflector.decode_type(type)
      @id = is_resource ? type.id : nil
      @attributes = attributes
      @relationships = {}
    end

    def set(key, value)
      attributes[key.to_sym] = value
      self
    end

    def set_related(relationship_key, related_resources)
      @relationships[relationship_key.to_sym] = related_resources
      self
    end

    def inspect
      attrs = ["id: #{id.inspect}"]
      attrs = attrs.concat(attributes.map { |name, value| "#{name}: #{value.inspect}" })
      attrs = attrs.concat(relationships.map { |name, value| "#{name}: #{value.inspect}" })
      inspection = attrs.join(", ")
      "#<#{self.class}[#{Inflector.classify(type)}] #{inspection}>"
    end
  end
end
