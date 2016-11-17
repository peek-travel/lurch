require_relative "../test_helper"

class TestCreateResources < Minitest::Test
  include LurchTest

  def test_post_new_resource_to_server_using_store
    stub_post(person_type, @response_factory.person_response("3", "Carol", code: :created))

    changeset = Lurch::Changeset.new(:person, name: "Carol")
    person = @store.insert(changeset)

    assert_requested :post, "#{@url}/#{person_type}", body: "{\"data\":{\"type\":\"#{person_type}\",\"attributes\":{\"name\":\"Carol\"}}}"
    assert_equal "3", person.id
    assert_equal "Carol", person.name
  end

  def test_post_new_resource_to_server_using_query
    stub_post(person_type, @response_factory.person_response("3", "Carol", code: :created))

    changeset = Lurch::Changeset.new(:person, name: "Carol")
    person = @store.to(:people).insert(changeset)

    assert_requested :post, "#{@url}/#{person_type}", body: "{\"data\":{\"type\":\"#{person_type}\",\"attributes\":{\"name\":\"Carol\"}}}"
    assert_equal "3", person.id
    assert_equal "Carol", person.name
  end

  def test_post_new_resource_to_server_with_relationship_to_existing_resources
    stub_get("#{phone_number_type}/1", @response_factory.phone_number_response("1", "Cell", "111-222-3344"))
    stub_post(person_type, @response_factory.person_response("3", "Carol", code: :created))

    phone_number = @store.from(:phone_numbers).find("1")

    changeset = Lurch::Changeset.new(:person, name: "Carol")
    changeset.set_related(:phone_numbers, [phone_number])
    person = @store.insert(changeset)

    assert_requested :post, "#{@url}/#{person_type}", body: "{\"data\":{\"type\":\"#{person_type}\",\"attributes\":{\"name\":\"Carol\"},\"relationships\":{\"#{@inflector.encode_key(:phone_numbers)}\":{\"data\":[{\"id\":\"1\",\"type\":\"#{phone_number_type}\"}]}}}}"
    assert_equal "3", person.id
    assert_equal "Carol", person.name
  end

  def test_validation_errors_when_posting_new_resource
    stub_post(person_type, @response_factory.unprocessable_entity_response("name - can't be blank"))

    changeset = Lurch::Changeset.new(:person, name: "")

    err = assert_raises(Lurch::Errors::UnprocessableEntity) { @store.insert(changeset) }

    assert_requested :post, "#{@url}/#{person_type}", body: "{\"data\":{\"type\":\"#{person_type}\",\"attributes\":{\"name\":\"\"}}}"
    assert_equal "422: name - can't be blank", err.message
    assert_equal 422, changeset.errors.first.status
    assert_equal "name - can't be blank", changeset.errors.first.detail
  end
end
