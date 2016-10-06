module Lurch
  class Changeset
    attr_reader :type, :id, :attributes

    def initialize(type, attributes = {})
      is_resource = type.is_a?(Resource)
      @type = is_resource ? type.type : Lurch.normalize_type(type)
      @id = is_resource ? type.id : nil
      @attributes = attributes
    end

    def payload
      {
        id: id,
        type: type,
        data: {
          attributes: attributes.each_with_object({}) do |(key, value), hash|
            hash[Inflecto.dasherize(key.to_s)] = value
          end
        }
      }.reject { |_, v| v.nil? }
    end
  end
end
