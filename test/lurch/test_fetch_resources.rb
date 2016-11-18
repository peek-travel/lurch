require_relative "../test_helper"

class TestFetchResources < Minitest::Test
  include LurchTest

  def test_fetch_resource_from_server
    stub_get("#{person_type}/1", @response_factory.person_response("1", "Alice"))

    person = @store.from(:people).find("1")

    assert_equal "Alice", person.name
    assert person.inspect
  end

  def test_fetch_resource_collection_from_server
    stub_get(person_type, @response_factory.people_response(["1", "Alice"], ["2", "Bob"]))

    people = @store.from(:people).all

    assert_kind_of Lurch::Collection, people
    assert_equal 2, people.size
    assert_equal ["Alice", "Bob"], people.map(&:name)
    assert people.inspect
  end

  def test_fetch_already_fetched_resource_from_store
    stub = stub_get("#{person_type}/1", @response_factory.person_response("1", "Alice"))

    @store.from(:people).find("1")

    remove_request_stub(stub)

    assert @store.from(:people).find("1")
  end

  def test_fetch_resource_from_server_that_includes_has_one_relationship
    stub_get("#{phone_number_type}/1", @response_factory.phone_number_response("1", "Cell", "111-222-3344", ["1", "Alice"]))

    phone_number = @store.from(:phone_numbers).find("1")

    assert_kind_of Lurch::Relationship::HasOne, phone_number.relationships[:contact]
    assert phone_number.relationships[:contact].inspect
    assert_kind_of Lurch::Resource, phone_number.contact
    assert_equal "Alice", phone_number.contact.name
  end

  def test_fetch_resource_from_server_that_includes_has_many_relationship
    stub = stub_get("#{person_type}/1", @response_factory.person_response("1", "Alice", [["1", "Cell", "1112223344"], ["2", "Home", "2221113344"]]))

    person = @store.from(:people).find("1")

    assert_kind_of Lurch::Relationship::HasMany, person.relationships[:phone_numbers]
    assert person.relationships[:phone_numbers].inspect
    assert_kind_of Array, person.phone_numbers
    assert_equal "Cell", person.phone_numbers.first.name
  end

  def test_fetch_resource_that_includes_resource_identifiers_only
    stub_get("#{person_type}/1", @response_factory.person_response("1", "Alice", [["1"]], include_phone_numbers: false))

    person = @store.from(:people).find("1")
    phone_number = person.phone_numbers.first

    assert_equal "1", phone_number.id
    refute phone_number.loaded?
    assert phone_number.inspect
    err = assert_raises(Lurch::Errors::ResourceNotLoaded) { phone_number.name }
    assert_equal "Resource (PhoneNumber) not loaded, try calling #fetch first.", err.message

    stub_get("#{phone_number_type}/1", @response_factory.phone_number_response("1", "Cell", "111-222-3344"))

    phone_number.fetch

    assert phone_number.loaded?
    assert_equal "Cell", phone_number.name
  end
end
