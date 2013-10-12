# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'riak_odm/version'

Gem::Specification.new do |spec|
  spec.name          = "riak_odm"
  spec.version       = RiakOdm::VERSION
  spec.authors       = ["Francesco Boffa"]
  spec.email         = ["fra.boffa@gmail.com"]
  spec.description   = 'RiakOdm is an ODM (Object-Document Mapper) Framework for Riak, written in Ruby'
  spec.summary       = 'RiakOdm is an ODM (Object-Document Mapper) Framework for Riak, written in Ruby'
  spec.homepage      = "https://github.com/AlfaOmega08/riak_odm"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(spec|features)/})
  spec.require_paths = %w{lib, vendor}

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_dependency "ruby-protocol-buffers", "~> 1.5.0"
end
