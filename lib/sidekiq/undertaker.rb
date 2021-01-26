# frozen_string_literal: true

require "sidekiq/undertaker/version"
require "sidekiq/undertaker/web_extension"

begin
  require "sidekiq/web"
rescue LoadError
  # client-only usage
end

if defined?(Sidekiq::Web)
  Sidekiq::Web.register Sidekiq::Undertaker::WebExtension
  Sidekiq::Web.tabs["Undertaker"] = "undertaker/filter"
  Sidekiq::Web.settings.locales << File.join(File.dirname(__FILE__), "../../web/locales")
end
