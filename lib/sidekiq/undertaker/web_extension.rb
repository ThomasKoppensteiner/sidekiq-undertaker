# frozen_string_literal: true

require "sidekiq/undertaker/web_extension/api_helpers"
require "pry"
module Sidekiq
  module Undertaker
    module WebExtension
      # rubocop:disable Metrics/MethodLength
      def self.registered(app)
        app.helpers APIHelpers

        app.get "/undertaker/filter" do
          show_filter
        end

        app.get "/undertaker/filter/:job_class/:bucket_name" do
          show_filter_by_job_class_bucket_name
        end

        app.get "/undertaker/morgue/:job_class/:error_class/:bucket_name" do
          show_undertaker_by_job_class_error_class_bucket_name
        end

        app.post "/undertaker/morgue" do
          post_undertaker
        end

        app.post "/undertaker/morgue/:job_class/:error_class/:bucket_name/delete" do
          post_undertaker_job_class_error_class_buckent_name_delete
        end

        app.post "/undertaker/morgue/:job_class/:error_class/:bucket_name/retry" do
          post_undertaker_job_class_error_class_buckent_name_retry
        end

        app.post "/undertaker/import_jobs" do
          post_import_jobs
        end
      end
      # rubocop:enable Metrics/MethodLength
    end
  end
end
