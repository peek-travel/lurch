module Lurch
  class Configuration
    def initialize(options)
      @options = options
    end

    def authorization
      @options[:authorization]
    end

    def request_id
      @options[:request_id]
    end

    def inflection_mode
      @options[:inflection_mode] || :dasherize
    end

    def types_mode
      @options[:types_mode] || :pluralize
    end
  end
end
