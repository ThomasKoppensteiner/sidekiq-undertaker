# frozen_string_literal: true

require "sidekiq/undertaker/dead_job"

module Sidekiq
  module Undertaker
    class JobFilter
      class << self
        def filter_dead_jobs(filters = {})
          # filters can have keys in (job_class, error_class, error_msg, bucket_name)
          dead_jobs = []
          Sidekiq::Undertaker::DeadJob.for_each do |dead_job|
            filter_passed = true
            filters.each do |filter, value|
              next if skip?(filter, value)

              filter_passed = false if dead_job.respond_to?(filter) && dead_job.public_send(filter) != value
            end
            dead_jobs << dead_job if filter_passed
          end

          dead_jobs
        end

        def skip?(filter, value)
          value.nil? ||
            total_dead_bucket?(filter, value) ||
            all_jobs?(filter, value) ||
            all_errors?(filter, value) ||
            all_error_msgs?(filter, value)
        end

        def total_dead_bucket?(filter, value)
          filter == "bucket_name" && value == "total_dead"
        end

        def all_jobs?(filter, value)
          filter == "job_class" && value == "all"
        end

        def all_errors?(filter, value)
          filter == "error_class" && value == "all"
        end

        def all_error_msgs?(filter, value)
          filter == "error_msg" && value == "all"
        end
      end
    end
  end
end
