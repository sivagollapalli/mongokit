# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mongokit/version'

Gem::Specification.new do |spec|
  spec.name          = "mongokit"
  spec.version       = Mongokit::VERSION
  spec.authors       = ["Jiren"]
  spec.email         = ["jirenpatel@gmail.com"]

  spec.summary       = %q{Helpers for mongoid i.e auto increment fields, search index}
  spec.description   = %q{Helpers for mongoid i.e auto increment fields, search index}
  spec.homepage      = "http://github.com/jiren/mongokit"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.9"
  spec.add_development_dependency "rake", "~> 10.0"

  spec.add_dependency("mongoid", "~> 4.0.0")
end
