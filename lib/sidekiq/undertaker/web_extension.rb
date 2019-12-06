# frozen_string_literal: true

require "sidekiq/undertaker/web_extension/api_helpers"

module Sidekiq
  module Undertaker
    module WebExtension
      def self.registered(app)
        app.helpers APIHelpers

        app.get "/undertaker" do
          show_undertaker
        end

        app.get "/undertaker/:job_class/:bucket_name" do
          show_undertaker_by_job_class_bucket_name
        end

        app.get "/undertaker/:job_class/:error_class/:bucket_name" do
          show_undertaker_by_job_class_error_class_bucket_name
        end

        app.post "/undertaker" do
          post_undertaker
        end

        app.post "/undertaker/:job_class/:error_class/:bucket_name/delete" do
          post_undertaker_job_class_error_class_buckent_name_delete
        end

        app.post "/undertaker/:job_class/:error_class/:bucket_name/retry" do
          post_undertaker_job_class_error_class_buckent_name_retry
        end
      end
    end
  end
end
