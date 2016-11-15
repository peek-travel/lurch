require "logger"

module Lurch
  class Configuration
    attr_accessor :logger, :log_payloads

    def initialize
      @logger = ::Logger.new(STDOUT)
      @logger.level = ::Logger::INFO

      @log_payloads = false
    end

    def pagination_record_count_key
      @options[:pagination_record_count_key] || :record_count
    end

    def pagination_page_count_key
      @options[:pagination_page_count_key] || :page_count
    end
  end
end
