# encoding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'simver/version'

Gem::Specification.new do |gem|
  gem.name          = 'simver'
  gem.version       = Simver::VERSION
  gem.authors       = ['Kendall Gifford']
  gem.email         = ['zettabyte@gmail.com']
  gem.description   =  'Simple version number library'
  gem.summary       =  "Simple version number library for representing semantic 'versions'"
  gem.homepage      =  'https://github.com/zettabyte/simver'

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'guard'
  gem.add_development_dependency 'guard-bundler'
  gem.add_development_dependency 'guard-rspec'
  gem.add_development_dependency 'guard-cane'
end
