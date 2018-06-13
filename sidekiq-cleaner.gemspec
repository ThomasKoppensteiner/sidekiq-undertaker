# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sidekiq/cleaner/version'

Gem::Specification.new do |spec|
  spec.name          = "sidekiq-cleaner"
  spec.version       = Sidekiq::Cleaner::VERSION
  spec.authors       = ["Madan Thangavelu"]
  spec.email         = ["madan.thangavelu@lookout.com"]
  spec.summary       = %q{Gem provides ability to dig through dead jobs in sidekiq.}
  spec.description   = %q{Gem provides ability to dig through dead jobs in sidekiq.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib", 'lib/sidekiq/cleaner']

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"

  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rspec-core'
  spec.add_development_dependency 'rspec-mocks'
  spec.add_development_dependency 'rspec-sidekiq'
  spec.add_development_dependency 'sinatra'
  spec.add_development_dependency 'rack-test'
  spec.add_development_dependency 'mock_redis'

  spec.add_runtime_dependency 'sidekiq', "> 3.0"
end
