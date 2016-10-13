module Lurch
  class PayloadBuilder
    def initialize(input, resource_identifier_only = false)
      @input = input
      @resource_identifier_only = resource_identifier_only
    end

    def build
      { "data" => data }
    end

  private

    def data
      if @input.is_a?(Enumerable)
        @input.map { |resource| resource_object_for(resource) }
      else
        resource_object_for(@input)
      end
    end

    def resource_object_for(resource)
      {
        "id" => resource.id,
        "type" => Inflecto.dasherize(resource.type.to_s),
        "attributes" => attributes_for(resource)
      }.reject { |_, v| v.nil? || (v.respond_to?(:empty?) && v.empty?) }
    end

    def attributes_for(resource)
      return {} if @resource_identifier_only
      dasherize_keys(resource.attributes)
    end

    def dasherize_keys(attributes)
      attributes.each_with_object({}) do |(key, value), hash|
        hash[Inflecto.dasherize(key.to_s)] = value
      end
    end
  end
end
