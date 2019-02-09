# frozen_string_literal: true

lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "sidekiq/cleaner/version"

Gem::Specification.new do |spec|
  spec.name          = "sidekiq-cleaner"
  spec.version       = Sidekiq::Cleaner::VERSION
  spec.authors       = ["Thomas Koppensteiner"]
  spec.email         = ["thomas.koppensteiner@gmx.net "]
  spec.summary       = "Sidekiq::Cleaner makes exploring the Sidekiq dead job queue easier"
  spec.description   = <<-DES
    Sidekiq::Cleaner is a plugin for Sidekiq.
    It makes exploring the dead job queue easier
    by breaking down the dead jobs into time windows (buckets) of hours and days.
    The gems allows retrying or deleting a certain subset of failures.
  DES
  spec.license       = "MIT"

  spec.homepage      = "https://github.com/ThomasKoppensteiner/sidekiq-cleaner"
  spec.metadata      = {
    "homepage_uri"     => "https://github.com/ThomasKoppensteiner/sidekiq-cleaner",
    "source_code_uri"  => "https://github.com/ThomasKoppensteiner/sidekiq-cleaner",
    "bug_tracker_uri"  => "https://github.com/ThomasKoppensteiner/sidekiq-cleaner/issues",
    "build_status_uri" => "https://travis-ci.org/ThomasKoppensteiner/sidekiq-cleaner"
  }

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib", "lib/sidekiq/cleaner"]

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"

  spec.add_development_dependency "approvals"
  spec.add_development_dependency "mock_redis"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "rack-test"
  spec.add_development_dependency "rb-readline"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "rspec-core"
  spec.add_development_dependency "rspec-mocks"
  spec.add_development_dependency "rspec-sidekiq"
  spec.add_development_dependency "rt_rubocop_defaults"
  spec.add_development_dependency "rubocop"
  spec.add_development_dependency "rubocop-rspec"
  spec.add_development_dependency "rubocop_runner"
  spec.add_development_dependency "simplecov"
  spec.add_development_dependency "sinatra"
  spec.add_development_dependency "timecop"

  spec.add_runtime_dependency "sidekiq", "> 3.0"
end
