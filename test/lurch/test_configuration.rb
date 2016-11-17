require_relative "../test_helper"

class TestConfiguration < Minitest::Test
  include LurchTest

  def test_configuration
    assert_kind_of Logger, Lurch.configuration.logger
    refute Lurch.configuration.log_payloads

    Lurch.configure do |config|
      config.log_payloads = true
    end

    assert Lurch.configuration.log_payloads

    Lurch.reset_configuration

    refute Lurch.configuration.log_payloads
  end
end
