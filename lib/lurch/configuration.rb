require "logger"

module Lurch
  class Configuration
    attr_accessor :logger, :log_payloads

    def initialize
      @logger = ::Logger.new(STDOUT)
      @logger.level = ::Logger::INFO

      @log_payloads = false
    end
  end
end
