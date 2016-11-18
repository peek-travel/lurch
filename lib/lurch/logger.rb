module Lurch
  class Logger
    def self.debug(&block)
      Lurch.configuration.logger.debug("Lurch", &block)
    end
  end
end
