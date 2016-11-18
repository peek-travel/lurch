require_relative "../test_helper"

class TestErrors < Minitest::Test
  include LurchTest

  def test_401
    stub_get("#{person_type}/1", @response_factory.unauthorized_response)
    err = assert_raises(Lurch::Errors::Unauthorized) { @store.from(:people).find("1") }
    assert_equal "401: Unauthorized", err.message
  end

  def test_403
    stub_get("#{person_type}/1", @response_factory.forbidden_response)
    err = assert_raises(Lurch::Errors::Forbidden) { @store.from(:people).find("1") }
    assert_equal "403: Forbidden", err.message
  end

  def test_404
    stub_get("#{person_type}/999", @response_factory.not_found_response)
    err = assert_raises(Lurch::Errors::NotFound) { @store.from(:people).find("999") }
    assert_equal "404: Not Found", err.message
  end

  def test_500
    stub_get("#{person_type}/1", @response_factory.server_error_response)
    err = assert_raises(Lurch::Errors::ServerError) { @store.from(:people).find("1") }
    assert_equal "500: Internal Server Error", err.message
  end
end
