require "coveralls"
require "pry"
require "simplecov"
require "webmock/minitest"

require_relative "helpers/lurch_test"
require_relative "helpers/response_factory"

SimpleCov.start do
  add_filter "/test/"
end

require "minitest/autorun"
require "lurch"
