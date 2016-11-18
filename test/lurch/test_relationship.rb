require_relative "../test_helper"

class TestRelationship < Minitest::Test
  include LurchTest

  def test_bad_relationship_document
    err = assert_raises(ArgumentError) { Lurch::Relationship.from_document(nil, nil, {}) }
    assert_equal "Invalid relationship document", err.message
  end

  def test_nil_has_one_relationship
    rel = Lurch::Relationship::HasOne.new(nil, nil, {data: nil})

    assert rel.loaded?
    assert_equal nil, rel.data
  end
end
