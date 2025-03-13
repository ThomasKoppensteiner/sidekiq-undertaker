# frozen_string_literal: true

# This file was generated by the `rspec --init` command. Conventionally, all
# specs live under a `spec` directory, which RSpec adds to the `$LOAD_PATH`.
# Require this file using `require "spec_helper"` to ensure that it is only
# loaded once.
#
# See http://rubydoc.info/gems/rspec-core/RSpec/Core/Configuration

ENV["RACK_ENV"] ||= ENV["ENVIRONMENT"] ||= "test"

require "bundler/setup"
Bundler.setup

require "approvals/rspec"
require "mock_redis"
require "pry"
require "rack/session"
require "rack/test"
require "sidekiq"
require "timecop"

if ENV["COVERAGE"]
  require "simplecov"
  require "simplecov_json_formatter"

  SimpleCov.formatter = SimpleCov::Formatter::JSONFormatter

  SimpleCov.start do
    add_group "lib", "lib"
    add_group "spec", "spec"

    maximum_coverage_drop 2
    # FIXME: JRuby reports different coverage on multi-line boolean statements like in `dead_job.rb`
    minimum_coverage_by_file 70 # 95
    minimum_coverage 95
  end
end

require "sidekiq/undertaker"

[
  "spec/support/**/*.rb"
].each do |pattern|
  Dir[File.join(pattern)].each { |file| require file.gsub("spec/", "") }
end

RSpec.configure do |config|
  config.run_all_when_everything_filtered = true
  config.filter_run :focus

  config.approvals_default_format = :txt

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = "random"
  Kernel.srand config.seed

  config.before do
    Sidekiq.redis(&:flushdb)
  end
end

def apply_custom_excludes(data)
  data.gsub!("Sidekiq v#{Sidekiq::VERSION}", "Sidekiq v*EXCLUDED*")
end

def build_job(item)
  Sidekiq::JobRecord.new(item)
end

def job_to_sorted_entry(job, score: Time.now.utc.to_i, set: Sidekiq::SortedSet.new("test-jobs"))
  Sidekiq::SortedEntry.new(set, score, job.item)
end

def kill_job(job)
  dead_set = Sidekiq::DeadSet.new
  dead_set.kill(Sidekiq.dump_json(job.item))
  dead_set.find_job(job.jid)
end

def push_job(params)
  jid = Sidekiq::Client.push(params)
  queue_name = params["queue"] || "default"
  Sidekiq::Queue.new(queue_name).find_job(jid)
end

Approvals.configure do |c|
  c.approvals_path = "spec/fixtures/approvals/"
end
