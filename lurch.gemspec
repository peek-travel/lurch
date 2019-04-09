# frozen_string_literal: true

require File.expand_path("lib/lurch/version", __dir__)

Gem::Specification.new do |gem|
  gem.name          = "lurch"
  gem.version       = Lurch::VERSION
  gem.summary       = "A simple Ruby JSON API client"
  gem.description   = "A client library for interacting with JSON API servers, based on http://jsonapi.org/ version 1.0."
  gem.homepage      = "https://github.com/peek-travel/lurch"
  gem.authors       = ["Chris Dosé"]
  gem.email         = "chris@peek.com"
  gem.license       = "MIT"

  gem.files         = `git ls-files`.split($RS)
  gem.require_paths = ["lib"]

  gem.add_dependency("faraday", "< 1.0")
  gem.add_dependency("inflecto", "~> 0.0")
  gem.add_dependency("rack", ">= 1.0")
  gem.add_dependency("typhoeus", "< 2.0")

  gem.add_development_dependency("codecov")
  gem.add_development_dependency("minitest")
  gem.add_development_dependency("pry")
  gem.add_development_dependency("rake")
  gem.add_development_dependency("rubocop")
  gem.add_development_dependency("webmock")
end
