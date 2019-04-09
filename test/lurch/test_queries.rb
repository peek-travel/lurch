require_relative "../test_helper"

class TestQueries < Minitest::Test
  include LurchTest

  def test_filter
    stub = stub_get(
      "#{person_type}?filter[name]=Alice&filter[foo][]=bar&filter[foo][]=baz",
      @response_factory.no_content_response
    )

    @store
      .from(:people)
      .filter(name: "Alice", foo: ["bar", "baz"])
      .all

    assert_requested(stub)
  end

  def test_include
    stub = stub_get(
      "#{person_type}?include=#{@inflector.encode_key(:phone_numbers)},friends,friends.#{@inflector.encode_key(:phone_numbers)}",
      @response_factory.no_content_response
    )

    @store
      .from(:people)
      .include(:phone_numbers, :friends, "friends.phone_numbers")
      .all

    assert_requested(stub)
  end

  def test_fields
    stub = stub_get(
      "#{person_type}?fields[#{person_type}]=name&fields[#{phone_number_type}]=name,number",
      @response_factory.no_content_response
    )

    @store
      .from(:people)
      .fields([:name])
      .fields(:phone_number, [:name, :number])
      .all

    assert_requested(stub)
  end

  def test_sort
    stub = stub_get(
      "#{person_type}?sort=name,-foo,bar",
      @response_factory.no_content_response
    )

    @store
      .from(:people)
      .sort(:name, {foo: :desc}, {bar: :asc})
      .all

    assert_requested(stub)
  end

  def test_bad_sort
    assert_raises ArgumentError do
      @store.from(:people).sort(foo: :bar).all
    end
  end

  def test_page
    stub = stub_get(
      "#{person_type}?page[number]=12&page[size]=50",
      @response_factory.no_content_response
    )

    @store
      .from(:people)
      .page(number: 12, size: 50)
      .all

    assert_requested(stub)
  end

  def test_params
    stub = stub_get(
      "#{person_type}?baz[boom]=baum&foo=bar",
      @response_factory.no_content_response
    )

    @store
      .from(:people)
      .params(foo: 'bar', baz: { boom: 'baum' })
      .all

    assert_requested(stub)
  end

  def test_all
    stub = stub_get(
      "#{person_type}?filter[name]=Alice&filter[foo][]=bar&filter[foo][]=baz&include=#{@inflector.encode_key(:phone_numbers)},friends,friends.#{@inflector.encode_key(:phone_numbers)}&fields[#{person_type}]=name&fields[#{phone_number_type}]=name,number&boom=baum&sort=name,-foo,bar&page[number]=12&page[size]=50",
      @response_factory.no_content_response
    )

    query = @store
      .from(:people)
      .filter(name: "Alice", foo: ["bar", "baz"])
      .include(:phone_numbers, :friends, "friends.phone_numbers")
      .fields([:name])
      .fields(:phone_number, [:name, :number])
      .params(boom: 'baum')
      .sort(:name, {foo: :desc}, {bar: :asc})
      .page(number: 12, size: 50)

    assert query.inspect

    query.all

    assert_requested(stub)
  end
end
