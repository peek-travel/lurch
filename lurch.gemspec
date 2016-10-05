# -*- encoding: utf-8 -*-
require File.expand_path("../lib/lurch/version", __FILE__)

Gem::Specification.new do |gem|
  gem.name          = "lurch"
  gem.version       = Lurch::VERSION
  gem.summary       = ""
  gem.description   = ""
  gem.homepage      = "https://github.com/gadabout/lurch"
  gem.authors       = ["Chris Dosé"]
  gem.email         = "chris@peek.com"

  gem.files         = `git ls-files`.split($RS)
  gem.require_paths = ["lib"]

  gem.add_dependency("faraday")
  gem.add_dependency("jsonapi", "0.1.1.beta2")
  gem.add_dependency("inflecto")

  gem.add_development_dependency("pry")
  gem.add_development_dependency("rspec")
  gem.add_development_dependency("rubocop")
  gem.add_development_dependency("rake")
  gem.add_development_dependency("geminabox")
end
