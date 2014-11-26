# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'dotnet/version'

Gem::Specification.new do |spec|
  spec.name          = "dotnet_solutions"
  spec.version       = DotNet::VERSION
  spec.authors       = ["The Tribe"]
  spec.email         = ["jbatte@gmail.com"]
  spec.summary       = %q{Provides access to .NET-specific file-based tasks.}
  spec.description   = %q{Used to generate and maintain metadata for .NET development.}
  spec.homepage      = "https://github.com/TheTribe/dotnet_solutions"
  spec.license       = "BSD 2-Clause"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"

  spec.add_runtime_dependency 'ember'
  spec.add_runtime_dependency 'json'
  spec.add_runtime_dependency 'pathname3'
end
