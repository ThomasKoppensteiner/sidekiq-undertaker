# frozen_string_literal: true

lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "sidekiq/undertaker/version"

Gem::Specification.new do |spec|
  spec.name          = "sidekiq-undertaker"
  spec.version       = Sidekiq::Undertaker::VERSION
  spec.authors       = ["Thomas Koppensteiner"]
  spec.email         = ["thomas.koppensteiner@gmx.net "]
  spec.summary       = "Sidekiq::Undertaker allows exploring, reviving or burying dead jobs"
  spec.description   = <<-DES
    Sidekiq::Undertaker is a plugin for Sidekiq.
    It allows exploring, reviving (retrying) or burying (deleting) dead jobs.
    For easy exploring the dead-jobs queue is broken down into time windows (buckets) of hours, days and weeks.
  DES
  spec.license       = "MIT"

  spec.homepage      = "https://github.com/ThomasKoppensteiner/sidekiq-undertaker"
  spec.metadata      = {
    "homepage_uri"          => "https://github.com/ThomasKoppensteiner/sidekiq-undertaker",
    "source_code_uri"       => "https://github.com/ThomasKoppensteiner/sidekiq-undertaker",
    "changelog_uri"         => "https://github.com/ThomasKoppensteiner/sidekiq-undertaker/blob/master/CHANGELOG.md",
    "bug_tracker_uri"       => "https://github.com/ThomasKoppensteiner/sidekiq-undertaker/issues",
    "build_status_uri"      => "https://github.com/ThomasKoppensteiner/sidekiq-undertaker/actions/workflows/ruby-build.yml",
    "rubygems_mfa_required" => "true"
  }

  spec.required_ruby_version = ">= 3.1.0"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib", "lib/sidekiq/undertaker"]

  spec.add_runtime_dependency "rubyzip", "~> 2.3"
  spec.add_runtime_dependency "sidekiq", "~> 7"
end
