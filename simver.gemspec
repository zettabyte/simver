# encoding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'simver/version'

Gem::Specification.new do |gem|
  gem.version       = Simver::VERSION
  gem.name          =  'simver'
  gem.authors       = ['Kendall Gifford']
  gem.email         = ['zettabyte@gmail.com']
  gem.homepage      =  'https://github.com/zettabyte/simver'
  gem.description   =  "Simple Version Library"
  gem.summary       = <<-SUMMARY.gsub(/^ {4}/, '')
    Simple version number library providing a version number type, Simver,
    for representing semantic version numbers.

    Sim-ple ver-sion library: simver.
  SUMMARY

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  gem.add_development_dependency 'rake',          '~> 10.0'
  gem.add_development_dependency 'bundler',       '~> 1.0'
  gem.add_development_dependency 'rspec',         '~> 2.13'
  gem.add_development_dependency 'cane',          '~> 2.5'
  gem.add_development_dependency 'guard',         '~> 1.7'
  gem.add_development_dependency 'guard-bundler', '~> 1.0'
  gem.add_development_dependency 'guard-rspec',   '~> 2.5'
  gem.add_development_dependency 'guard-cane',    '~> 0.1.2'
end

