require_relative "../test_helper"

class TestResource < Minitest::Test
  include LurchTest

  def test_resource_equality
    stub_get("#{person_type}/1", @response_factory.person_response("1", "Alice"))
    stub_get("#{person_type}/2", @response_factory.person_response("2", "Bob"))

    person1 = @store.from(:people).find("1")
    person1_again = @store.from(:people).find("1")
    person2 = @store.from(:people).find("2")

    assert person1 == person1_again
    assert person1.eql? person1_again
    refute person1.equal? person1_again
    refute person1 == person2
    refute person1.eql? person2
    refute person1.equal? person2
  end

  def test_resource_attribute_getters
    stub_get("#{person_type}/1", @response_factory.person_response("1", "Alice"))

    person = @store.from(:people).find("1")

    assert person.name == "Alice"
    assert person[:name] == "Alice"
    assert person.respond_to?(:name)

    refute person.respond_to?(:foo)
    assert_raises(NoMethodError) { person.foo }
  end
end
