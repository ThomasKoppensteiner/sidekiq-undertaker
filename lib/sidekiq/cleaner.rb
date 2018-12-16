# frozen_string_literal: true

require "sidekiq/cleaner/version"
require "sidekiq/cleaner/dead_job"
require "sidekiq/cleaner/job_filter"
require "sidekiq/cleaner/web_extension"
require "sidekiq/cleaner/bucket"
require "sidekiq/cleaner/job_aggregator"

begin
  require "sidekiq/web"
rescue LoadError
  # client-only usage
end

if defined?(Sidekiq::Web)
  Sidekiq::Web.register Sidekiq::Cleaner::WebExtension
  Sidekiq::Web.tabs["Cleaner"] = "cleaner"
end
