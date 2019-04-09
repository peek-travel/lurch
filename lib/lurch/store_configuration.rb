# frozen_string_literal: true

module Lurch
  class StoreConfiguration
    def initialize(options)
      @options = options
    end

    def authorization
      @options[:authorization]
    end

    def inflection_mode
      @options[:inflection_mode] || :dasherize
    end

    def types_mode
      @options[:types_mode] || :pluralize
    end

    def pagination_record_count_key
      @options[:pagination_record_count_key] || :record_count
    end

    def pagination_page_count_key
      @options[:pagination_page_count_key] || :page_count
    end
  end
end
