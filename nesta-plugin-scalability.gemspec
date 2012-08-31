# -*- encoding: utf-8 -*-
require File.expand_path('../lib/nesta-plugin-scalability/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Joshua Mervine"]
  gem.email         = ["joshua@mervine.net"]
  gem.description   = %q{Allows for scablability by saving to Mongodb as well as the filesystem.}
  gem.summary       = gem.description
  gem.homepage      = "http://github.com/jmervine/nesta-plugin-scalability"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "nesta-plugin-scalability"
  gem.require_paths = ["lib"]
  gem.version       = Nesta::Plugin::Scalability::VERSION
  gem.add_dependency("nesta", ">= 0.9.11")
  gem.add_dependency("mongodb", ">= 2.1.0")
  gem.add_dependency("bson_ext", ">= 1.7.0")
  gem.add_development_dependency("rake")
  gem.add_development_dependency("rspec")
  gem.add_development_dependency("simplecov")
end
