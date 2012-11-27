$LOAD_PATH << File.expand_path('../lib', __FILE__)
require 'rake'
require 'ebnf/version'

Gem::Specification.new do |spec|
  spec.name        = 'ebnf'
  spec.version     = EBNF::VERSION
  spec.author      = 'feivel jellyfish'
  spec.email       = 'feivel@sdf.org'
  spec.files       = FileList['ebnf.gemspec','lib/**/*.rb']
  spec.test_files  = FileList['Rakefile','test/**/*.rb']
  spec.homepage    = 'http://github.com/gwentacle/ebnf'
  spec.summary     = 'Extended Backus-Naur Form implementation for Ruby'
  spec.description = 'Extended Backus-Naur Form implementation for Ruby'
  spec.add_development_dependency 'graham', '>=0.0.2'
end

