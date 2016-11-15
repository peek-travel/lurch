module Lurch
  class Railtie < ::Rails::Railtie
    initializer "lurch.initialization" do
      Lurch.configure do |config|
        config.logger = Rails.logger
      end
    end
  end
end
