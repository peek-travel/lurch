# frozen_string_literal: true

require_relative "../test_helper"

class TestCustomizeFaraday < Minitest::Test
  include LurchTest

  def test_customize_faraday
    stub = stub_request(
      :get,
      "#{@url}/people"
    ).with(headers: { 'X-Request-Id' => '123' })

    store = Lurch::Store.new(@url) do |conn|
      conn.headers['X-Request-Id'] = '123'
    end

    store.from(:people).all

    assert_requested(stub)
  end
end
