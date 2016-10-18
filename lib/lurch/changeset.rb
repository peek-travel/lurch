module Lurch
  class Changeset
    attr_reader :id, :type, :attributes, :relationships

    def initialize(type, attributes = {})
      is_resource = type.is_a?(Resource)
      @type = is_resource ? type.type : Lurch.normalize_type(type)
      @id = is_resource ? type.id : nil
      @attributes = attributes
      @relationships = {}
    end

    def add_related(relationship_key, related_resources)
      @relationships[relationship_key.to_sym] = related_resources
      self
    end

    def inspect
      attrs = ["id: #{id.inspect}"]
      attrs = attrs.concat attributes.map { |name, value| "#{name}: #{value.inspect}" }
      attrs = attrs.concat relationships.map { |name, value| "#{name}: #{value.inspect}" }
      inspection = attrs.join(", ")
      "#<#{self.class}[#{Inflecto.classify(type)}] #{inspection}>"
    end
  end
end
