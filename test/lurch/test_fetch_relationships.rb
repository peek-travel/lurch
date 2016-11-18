require_relative "../test_helper"

class TestFetchRelationships < Minitest::Test
  include LurchTest

  def test_fetch_linked_has_one_relationship_from_server
    stub_get("#{phone_number_type}/1", @response_factory.phone_number_response("1", "Cell", "111-222-3344"))
    stub_get("#{phone_number_type}/1/contact", @response_factory.person_response("1", "Alice"))

    phone_number = @store.from(:phone_numbers).find("1")

    assert_kind_of Lurch::Relationship::Linked, phone_number.contact
    assert phone_number.contact.inspect
    assert_raises(Lurch::Errors::RelationshipNotLoaded) { phone_number.contact.name }
    err = assert_raises(Lurch::Errors::RelationshipNotLoaded) { phone_number.contact.respond_to?(:name) }
    assert_equal "Relationship (contact) not loaded, try calling #fetch first.", err.message

    phone_number.contact.fetch
    person = phone_number.contact

    assert_kind_of Lurch::Resource, person
    assert_kind_of Lurch::Relationship::Linked, phone_number.relationships[:contact]
    assert_raises(NoMethodError) { phone_number.relationships[:contact].name }
    refute phone_number.relationships[:contact].respond_to?(:name)
    assert_equal "Alice", person.name
  end

  def test_fetch_linked_has_many_relationship_from_server
    stub_get("#{person_type}/1", @response_factory.person_response("1", "Alice"))
    stub_get(
      "#{person_type}/1/#{@inflector.encode_key(:phone_numbers)}",
      @response_factory.phone_numbers_response(["1", "Cell", "111-222-3344"], ["2", "Home", "222-111-3344"])
    )

    person = @store.from(:people).find("1")

    assert_kind_of Lurch::Relationship::Linked, person.phone_numbers
    assert person.phone_numbers.inspect

    person.phone_numbers.fetch
    phone_numbers = person.phone_numbers

    assert_kind_of Lurch::Collection, phone_numbers
    assert_kind_of Lurch::Relationship::Linked, person.relationships[:phone_numbers]
    assert_equal 2, phone_numbers.size
    assert_equal "Cell", phone_numbers.first.name
  end
end
