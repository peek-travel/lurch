module Lurch
  class Logger
    def self.debug(&block)
      Lurch.configuration.logger.debug("Lurch", &block)
    end

    def self.info(&block)
      Lurch.configuration.logger.info("Lurch", &block)
    end

    def self.error(&block)
      Lurch.configuration.logger.error("Lurch", &block)
    end

    def self.fatal(&block)
      Lurch.configuration.logger.fatal("Lurch", &block)
    end
  end
end
