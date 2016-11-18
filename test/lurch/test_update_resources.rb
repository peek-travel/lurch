require_relative "../test_helper"

class TestUpdateResources < Minitest::Test
  include LurchTest

  def test_update_existing_resource_on_server_using_store
    stub_get("#{person_type}/2", @response_factory.person_response("2", "Bob"))
    stub_patch("#{person_type}/2", @response_factory.person_response("2", "Robert"))

    person = @store.from(:people).find("2")

    assert_equal "Bob", person.name

    changeset = Lurch::Changeset.new(person, name: "Robert")
    @store.save(changeset)

    assert changeset.inspect
    assert_requested :patch, "#{@url}/#{person_type}/2", body: "{\"data\":{\"id\":\"2\",\"type\":\"#{person_type}\",\"attributes\":{\"name\":\"Robert\"}}}"
    assert_equal "Robert", person.name
  end

  def test_update_existing_resource_on_server_using_query
    stub_get("#{person_type}/2", @response_factory.person_response("2", "Bob"))
    stub_patch("#{person_type}/2", @response_factory.person_response("2", "Robert"))

    person = @store.from(:people).find("2")

    assert_equal "Bob", person.name

    changeset = Lurch::Changeset.new(person)
    changeset.set(:name, "Robert")
    @store.to(:people).save(changeset)

    assert_requested :patch, "#{@url}/#{person_type}/2", body: "{\"data\":{\"id\":\"2\",\"type\":\"#{person_type}\",\"attributes\":{\"name\":\"Robert\"}}}"
    assert_equal "Robert", person.name
  end

  def test_validation_errors_when_updating_existing_resource
    stub_get("#{person_type}/2", @response_factory.person_response("2", "Bob"))
    stub_patch("#{person_type}/2", @response_factory.unprocessable_entity_response("name - can't be blank"))

    person = @store.from(:people).find("2")

    assert_equal "Bob", person.name

    changeset = Lurch::Changeset.new(person, name: "")

    err = assert_raises(Lurch::Errors::UnprocessableEntity) { @store.save(changeset) }
    assert_equal "422: name - can't be blank", err.message
    assert_equal 422, changeset.errors.first.status
    assert_equal "name - can't be blank", changeset.errors.first.detail

    assert_requested :patch, "#{@url}/#{person_type}/2", body: "{\"data\":{\"id\":\"2\",\"type\":\"#{person_type}\",\"attributes\":{\"name\":\"\"}}}"
    assert_equal "Bob", person.name
  end
end
