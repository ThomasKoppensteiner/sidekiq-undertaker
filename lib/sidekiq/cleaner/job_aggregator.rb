# frozen_string_literal: true

module Sidekiq
  module Cleaner
    class JobAggregator
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

      private

      def group_by(attribute)
        distribution = init_all_error_counts

        dead_jobs.each do |dead_job|
          attr        = dead_job.public_send(attribute)
          bucket_name = dead_job.bucket_name

          distribution = init_attr_counts(distribution, attr, bucket_name) unless distribution[attr]
          distribution = init_bucket_counts(distribution, attr, bucket_name) unless distribution[attr][bucket_name]

          distribution = incr_counters(distribution, attr, bucket_name)
        end

        distribution
      end

      def init_all_error_counts
        distribution = {}

        distribution["AllErrors"] = {}
        distribution["AllErrors"]["total_failures"] = 0
        distribution
      end

      def init_attr_counts(distribution, attr, bucket_name)
        distribution[attr] = {}
        distribution[attr]["total_failures"] = 0

        distribution["AllErrors"][bucket_name] = 0 unless distribution["AllErrors"][bucket_name]
        distribution
      end

      def init_bucket_counts(distribution, attr, bucket_name)
        distribution[attr][bucket_name] = 0
        distribution["AllErrors"][bucket_name] = 0 unless distribution["AllErrors"][bucket_name]
        distribution
      end

      def incr_counters(distribution, attr, bucket_name, value = 1)
        distribution[attr][bucket_name] += value
        distribution[attr]["total_failures"] += value

        distribution["AllErrors"][bucket_name] += value
        distribution["AllErrors"]["total_failures"] += value
        distribution
      end
    end
  end
end
