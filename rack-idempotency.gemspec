# frozen_string_literal: true

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rack/idempotency/version'

Gem::Specification.new do |spec|
  spec.name          = 'rack-idempotency'
  spec.version       = Rack::Idempotency::VERSION
  spec.authors       = ['Egor Dovnar', 'Matt Pruitt']
  spec.email         = ['egordovnar.job@gmail.com']

  spec.summary       = %q{Rack middleware for idempotency guarantees in mutating endpoints.}
  spec.homepage      = 'https://github.com/StalemateInc/rack-idempotency'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'rack'
  spec.add_dependency 'redis', '~> 4.7'

  spec.add_development_dependency 'bundler', '~> 2.3'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rspec', '~> 3.11'
  spec.add_development_dependency 'simplecov'
end
