require_relative "../test_helper"

class TestPaginatedCollections < Minitest::Test
  include LurchTest

  def test_fetch_paginated_resource_collection_from_server
    stub_get(person_type, @response_factory.paginated_people_response(10, 1, 2))

    people = @store.from(:people).all

    assert_kind_of Lurch::Collection, people
    assert_equal 20, people.size
    assert_equal 10, people.page_size
    assert_equal 2, people.page_count
  end

  def test_fetch_next_page_of_paginated_resource_collection_from_server
    stub_get(person_type, @response_factory.paginated_people_response(10, 1, 2))

    people = @store.from(:people).all

    assert people.next?

    page2_stub = stub_get("#{person_type}?page[number]=2&page[size]=10", @response_factory.paginated_people_response(10, 2, 2))

    people.next_collection

    assert_requested page2_stub
  end

  def test_fetch_previous_page_of_paginated_resource_collection_from_server
    stub_get("#{person_type}?page[number]=2&page[size]=10", @response_factory.paginated_people_response(10, 2, 2))

    people = @store.from(:people).page(number: 2, size: 10).all

    assert people.prev?

    page1_stub = stub_get("#{person_type}?page[number]=1&page[size]=10", @response_factory.paginated_people_response(10, 1, 2))

    people.prev_collection

    assert_requested page1_stub
  end

  def test_fetch_first_page_of_paginated_resource_collection_from_server
    stub_get("#{person_type}?page[number]=2&page[size]=10", @response_factory.paginated_people_response(10, 2, 2))

    people = @store.from(:people).page(number: 2, size: 10).all

    assert people.first?

    page1_stub = stub_get("#{person_type}?page[number]=1&page[size]=10", @response_factory.paginated_people_response(10, 1, 2))

    people.first_collection

    assert_requested page1_stub
  end

  def test_fetch_last_page_of_paginated_resource_collection_from_server
    stub_get(person_type, @response_factory.paginated_people_response(10, 1, 2))

    people = @store.from(:people).all

    assert people.last?

    page2_stub = stub_get("#{person_type}?page[number]=2&page[size]=10", @response_factory.paginated_people_response(10, 2, 2))

    people.last_collection

    assert_requested page2_stub
  end

  def test_enumerate_paginated_collection_by_resource
    page1_stub = stub_get(person_type, @response_factory.paginated_people_response(10, 1, 3))
    page2_stub = stub_get("#{person_type}?page[number]=2&page[size]=10", @response_factory.paginated_people_response(10, 2, 3))
    page3_stub = stub_get("#{person_type}?page[number]=3&page[size]=10", @response_factory.paginated_people_response(10, 3, 3))

    people = @store.from(:people).all
    names = people.map(&:name)

    assert_kind_of Array, names
    assert names.size == 30
    assert names.first == "Person1"
    assert names.last == "Person30"

    assert_requested page1_stub
    assert_requested page2_stub
    assert_requested page3_stub
  end

  def test_enumerate_paginated_collection_by_page
    page1_stub = stub_get(person_type, @response_factory.paginated_people_response(10, 1, 3))
    page2_stub = stub_get("#{person_type}?page[number]=2&page[size]=10", @response_factory.paginated_people_response(10, 2, 3))
    page3_stub = stub_get("#{person_type}?page[number]=3&page[size]=10", @response_factory.paginated_people_response(10, 3, 3))

    people = @store.from(:people).all

    people.each_page do |page|
      assert_kind_of Array, page
      assert page.size == 10
    end

    assert_requested page1_stub
    assert_requested page2_stub
    assert_requested page3_stub
  end

  def test_lazy_enumeration
    page1_stub = stub_get(person_type, @response_factory.paginated_people_response(10, 1, 3))
    page2_stub = stub_get("#{person_type}?page[number]=2&page[size]=10", @response_factory.paginated_people_response(10, 2, 3))
    page3_stub = stub_get("#{person_type}?page[number]=3&page[size]=10", @response_factory.paginated_people_response(10, 3, 3))

    people = @store.from(:people).all
    names = people.lazy.map(&:name).first(20)

    assert_kind_of Array, names
    assert names.size == 20
    assert names.first == "Person1"
    assert names.last == "Person20"

    assert_requested page1_stub
    assert_requested page2_stub
    assert_not_requested page3_stub
  end
end
