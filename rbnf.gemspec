$LOAD_PATH << File.expand_path('../lib', __FILE__)
require 'rake'
require 'rbnf/version'

Gem::Specification.new do |spec|
  spec.name        = 'rbnf'
  spec.version     = RBNF::VERSION
  spec.author      = 'feivel jellyfish'
  spec.email       = 'feivel@sdf.org'
  spec.files       = FileList['rbnf.gemspec','lib/**/*.rb']
  spec.test_files  = FileList['Rakefile','test/**/*.rb']
  spec.homepage    = 'http://github.com/gwentacle/rbnf'
  spec.summary     = 'Extended Backus-Naur Form implementation for Ruby'
  spec.description = 'Extended Backus-Naur Form implementation for Ruby'
  spec.add_development_dependency 'graham', '>=0.0.3'
end

