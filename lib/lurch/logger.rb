# frozen_string_literal: true

module Lurch
  class Logger
    def self.debug(&block)
      Lurch.configuration.logger.debug("Lurch", &block)
    end
  end
end
