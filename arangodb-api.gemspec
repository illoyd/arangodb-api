# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'arangodb/api/version'

Gem::Specification.new do |spec|
  spec.name          = "arangodb-api"
  spec.version       = ArangoDB::API::VERSION
  spec.authors       = ["Ian Lloyd"]
  spec.email         = ["ian.w.lloyd@gmail.com"]

  spec.summary       = %q{Simple interface for the ArangoDB HTTP API.}
  spec.description   = %q{Access the ArangoDB HTTP API simply and efficiently.}
  spec.homepage      = "http://github.com/illoyd/arangodb-api"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "activesupport", ">= 5.0.0.beta1"
  spec.add_dependency 'net-http-persistent', '>= 2.9.4'
  spec.add_dependency "faraday", ">= 0.9.2"
  spec.add_dependency "faraday_middleware", ">= 0.10.0"
  spec.add_dependency "oj", ">= 2.14.4"

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rspec-its", "~> 1.2"
  spec.add_development_dependency "climate_control"
  spec.add_development_dependency "simplecov", "~> 0.11"
  spec.add_development_dependency "guard-rspec", "~> 4.6"
  spec.add_development_dependency "fuubar", "~> 2.0"
  spec.add_development_dependency 'faker'

end
