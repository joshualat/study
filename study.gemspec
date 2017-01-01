# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'study/version'

included_files = [
  'text_highlight',
  'tree_node',
  'version'
].map { |filename| "lib/study/#{ filename }.rb" }

included_files << 'lib/study.rb'

Gem::Specification.new do |spec|
  spec.name          = 'study'
  spec.version       = Study::VERSION
  spec.authors       = ['Joshua Arvin Lat']
  spec.email         = ['joshua.arvin.lat@gmail.com']
  spec.summary       = %q{Study Ruby objects, hashes, and arrays by exposing their internal structure with trees, colors, and indentation}
  spec.description   = %q{Study Ruby objects, hashes, and arrays by exposing their internal structure with trees, colors, and indentation}
  spec.homepage      = ''
  spec.license       = 'MIT'
  spec.files         = included_files
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency 'bundler', "~> 1.5"
  spec.add_development_dependency 'rake'
end