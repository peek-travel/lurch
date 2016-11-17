require_relative "../test_helper"

class TestDeleteResources < Minitest::Test
  include LurchTest

  def test_delete_existing_resource_from_server_using_store
    stub_get("#{person_type}/1", @response_factory.person_response("1", "Alice"))
    delete_stub = stub_delete("#{person_type}/1", @response_factory.no_content_response)

    person = @store.from(:people).find("1")
    response = @store.delete(person)

    assert_requested delete_stub
    assert response
  end

  def test_delete_existing_resource_from_server_using_query
    stub_get("#{person_type}/1", @response_factory.person_response("1", "Alice"))
    delete_stub = stub_delete("#{person_type}/1", @response_factory.no_content_response)

    person = @store.from(:people).find("1")
    response = @store.from(:people).delete(person)

    assert_requested delete_stub
    assert response
  end
end
