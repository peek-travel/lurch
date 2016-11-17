require_relative "../test_helper"

class TestUpdateRelationships < Minitest::Test
  include LurchTest

  def test_add_resources_to_has_many_relationship
    stub_get("#{person_type}/1", @response_factory.person_response("1", "Alice"))
    stub_get("#{phone_number_type}/1", @response_factory.phone_number_response("1", "Cell", "111-222-3344"))
    stub_post("#{person_type}/1/relationships/#{@inflector.encode_key(:phone_numbers)}", @response_factory.no_content_response)

    person = @store.from(:people).find("1")
    phone_number = @store.from(:phone_numbers).find("1")
    response = @store.add_related(person, :phone_numbers, [phone_number])

    assert_requested :post, "#{@url}/#{person_type}/1/relationships/#{@inflector.encode_key(:phone_numbers)}", body: "{\"data\":[{\"id\":\"1\",\"type\":\"#{phone_number_type}\"}]}"
    assert response
  end

  def test_remove_resources_from_has_many_relationship
    stub_get("#{person_type}/1", @response_factory.person_response("1", "Alice"))
    stub_get("#{person_type}/1/#{@inflector.encode_key(:phone_numbers)}", @response_factory.phone_numbers_response(["1", "Cell", "111-222-3344"]))
    stub_delete("#{person_type}/1/relationships/#{@inflector.encode_key(:phone_numbers)}", @response_factory.no_content_response)

    person = @store.from(:people).find("1")
    phone_number = person.phone_numbers.fetch.first
    response = @store.remove_related(person, :phone_numbers, [phone_number])

    assert_requested :delete, "#{@url}/#{person_type}/1/relationships/#{@inflector.encode_key(:phone_numbers)}", body: "{\"data\":[{\"id\":\"1\",\"type\":\"#{phone_number_type}\"}]}"
    assert response
  end

  def test_replace_resources_for_has_many_relationship
    stub_get("#{person_type}/1", @response_factory.person_response("1", "Alice"))
    stub_patch("#{person_type}/1/relationships/#{@inflector.encode_key(:phone_numbers)}", @response_factory.no_content_response)

    person = @store.from(:people).find("1")
    response = @store.update_related(person, :phone_numbers, [])

    assert_requested :patch, "#{@url}/#{person_type}/1/relationships/#{@inflector.encode_key(:phone_numbers)}", body: '{"data":[]}'
    assert response
  end

  def test_replace_resource_for_has_one_relationship
    stub_get("#{phone_number_type}/1", @response_factory.phone_number_response("1", "Cell", "111-222-3344"))
    stub_patch("#{phone_number_type}/1/relationships/contact", @response_factory.no_content_response)

    phone_number = @store.from(:phone_numbers).find("1")
    response = @store.update_related(phone_number, :contact, nil)

    assert_requested :patch, "#{@url}/#{phone_number_type}/1/relationships/contact", body: '{"data":null}'
    assert response
  end
end
