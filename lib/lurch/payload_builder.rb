module Lurch
  class PayloadBuilder
    def initialize(inflector)
      @inflector = inflector
    end

    def build(input, identifier_only = false)
      { "data" => data(input, identifier_only) }
    end

  private

    def data(input, identifier_only)
      if input.is_a?(Enumerable)
        input.map { |resource| resource_object_for(resource, identifier_only) }
      else
        resource_object_for(input, identifier_only)
      end
    end

    def resource_object_for(resource, identifier_only)
      {
        "id" => resource.id,
        "type" => @inflector.encode_type(resource.type),
        "attributes" => attributes_for(resource, identifier_only),
        "relationships" => relationships_for(resource, identifier_only)
      }.reject { |_, v| v.nil? || (v.respond_to?(:empty?) && v.empty?) }
    end

    def attributes_for(resource, identifier_only)
      return {} if identifier_only
      @inflector.encode_keys(resource.attributes)
    end

    def relationships_for(resource, identifier_only)
      return {} if identifier_only
      @inflector.encode_keys(resource.relationships) do |value|
        PayloadBuilder.new(@inflector).build(value, true)
      end
    end
  end
end
