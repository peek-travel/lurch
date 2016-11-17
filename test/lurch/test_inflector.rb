require_relative "../test_helper"

class TestInflector < Minitest::Test
  include LurchTest

  def test_bad_inflector
    err = assert_raises(ArgumentError) { Lurch::Inflector.new(:foo, :pluralize) }
    assert_equal "Invalid inflection mode: foo", err.message

    err = assert_raises(ArgumentError) { Lurch::Inflector.new(:dasherize, :bar) }
    assert_equal "Invalid types mode: bar", err.message
  end
end
