module Lurch
  class Changeset
    attr_reader :id, :type, :attributes

    def initialize(type, attributes = {})
      is_resource = type.is_a?(Resource)
      @type = is_resource ? type.type : Lurch.normalize_type(type)
      @id = is_resource ? type.id : nil
      @attributes = attributes
    end

    def inspect
      attrs = ["id: #{id.inspect}"]
      attrs = attrs.concat attributes.map { |name, value| "#{name}: #{value.inspect}" }
      inspection = attrs.join(", ")
      "#<#{self.class}[#{Inflecto.classify(type)}] #{inspection}>"
    end
  end
end
