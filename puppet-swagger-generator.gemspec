# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'puppet-swagger-generator/meta'

Gem::Specification.new do |spec|
  spec.name          = "puppet-swagger-generator"
  spec.version       = Puppet::Swagger::Generator::Meta::VERSION
  spec.authors       = ["Gareth Rushgrove"]
  spec.email         = ["gareth@morethanseven.net"]
  spec.summary       = %q{Generate Puppet types and providers from a Swagger specification}
  spec.homepage      = "https://github.com/garethr/puppet-swagger-generator"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"

  spec.add_dependency "clamp"
end
