require File.expand_path("../lib/lurch/version", __FILE__)

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
  gem.add_dependency("typhoeus", "< 2.0")

  gem.add_development_dependency("codecov", "~> 0.1")
  gem.add_development_dependency("minitest", "~> 5.9")
  gem.add_development_dependency("pry", "~> 0.10")
  gem.add_development_dependency("rake", "~> 12.2")
  gem.add_development_dependency("rubocop", "~> 0.43")
  gem.add_development_dependency("webmock", "~> 3.1")
end
