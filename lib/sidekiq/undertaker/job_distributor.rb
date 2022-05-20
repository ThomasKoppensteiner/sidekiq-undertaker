# frozen_string_literal: true

require "sidekiq/undertaker/bucket"

module Sidekiq
  module Undertaker
    class JobDistributor
      attr_reader :dead_jobs

      def initialize(dead_jobs)
        @dead_jobs = dead_jobs
      end

      def group_by_job_class
        group_by(:job_class)
      end

      def group_by_error_class
        group_by(:error_class)
      end

      def group_by_error_msg
        group_by(:error_msg)
      end

      private

      def distribute
        distribution = init_counters({}, "all")

        dead_jobs.each do |dead_job|
          bucket_name = dead_job.bucket_name

          incr_counters(distribution, "all", bucket_name)
          yield distribution, dead_job, bucket_name if block_given?
        end

        sort_by_total_dead(distribution)
      end

      def group_by(attribute)
        distribute do |distribution, dead_job, bucket_name|
          attr = dead_job.public_send(attribute)
          init_counters(distribution, attr) unless distribution[attr]
          incr_counters(distribution, attr, bucket_name)
        end
      end

      def sort_by_total_dead(distribution)
        distribution.map { |k, v| [k, v] }.sort do |x, y|
          x[1]["total_dead"] <=> y[1]["total_dead"]
        end.reverse
      end

      def init_counters(distribution, attr)
        distribution[attr] = {}
        Bucket.bucket_names.each { |bucket| distribution[attr][bucket] = 0 }
        distribution[attr]["total_dead"] = 0
        distribution
      end

      def incr_counters(distribution, attr, bucket_name, value = 1)
        distribution[attr][bucket_name] += value
        distribution[attr]["total_dead"] += value
      end
    end
  end
end
