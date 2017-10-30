require "coveralls"
require "pry"
require "simplecov"
require "codecov"
require "webmock/minitest"

require_relative "helpers/lurch_test"
require_relative "helpers/response_factory"

SimpleCov.formatter = SimpleCov::Formatter::Codecov
SimpleCov.start do
  add_filter "/test/"
end

require "minitest/autorun"
require "lurch"
