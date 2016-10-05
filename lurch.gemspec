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

  gem.add_dependency("faraday", "~> 0.9")
  gem.add_dependency("inflecto", "~> 0.0")

  gem.add_development_dependency("pry", "~> 0.10")
  gem.add_development_dependency("rspec", "~> 3.5")
  gem.add_development_dependency("rubocop", "~> 0.43")
  gem.add_development_dependency("rake", "~> 11.3")
end
