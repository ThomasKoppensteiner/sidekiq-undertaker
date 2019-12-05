# frozen_string_literal: true

require "sidekiq/undertaker/version"
require "sidekiq/undertaker/dead_job"
require "sidekiq/undertaker/job_filter"
require "sidekiq/undertaker/web_extension"
require "sidekiq/undertaker/bucket"
require "sidekiq/undertaker/job_aggregator"

begin
  require "sidekiq/web"
rescue LoadError # rubocop:disable Lint/SuppressedException
  # client-only usage
end

if defined?(Sidekiq::Web)
  Sidekiq::Web.register Sidekiq::Undertaker::WebExtension
  Sidekiq::Web.tabs["Undertaker"] = "undertaker"
  Sidekiq::Web.settings.locales << File.join(File.dirname(__FILE__), "../../web/locales")
end
