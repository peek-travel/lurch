module Lurch
  class Error
    JSON_API_ERROR_FIELDS = %w(id links about status code title detail source meta).freeze

    attr_reader(*JSON_API_ERROR_FIELDS)

    def initialize(error_object)
      JSON_API_ERROR_FIELDS.each do |field|
        instance_variable_set("@#{field}", error_object[field])
      end
    end
  end
end
