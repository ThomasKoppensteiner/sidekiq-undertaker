# frozen_string_literal: true

require "sidekiq/undertaker/bucket"

module Sidekiq
  module Undertaker
    class DeadJob
      class << self
        def for_each
          Sidekiq::DeadSet.new.each do |job|
            yield to_dead_job(job)
          end
        end

        def to_dead_job(job)
          job_failed_at                  = parsed_failed_at(job)
          job_time_elapsed_since_failure = Time.now.to_i - job_failed_at.to_i
          job_bucket_name                = Bucket.for_elapsed_time(job_time_elapsed_since_failure)

          new(job:                        job,
              time_elapsed_since_failure: job_time_elapsed_since_failure,
              bucket_name:                job_bucket_name)
        end

        def parsed_failed_at(job)
          job.item["failed_at"].is_a?(String) ? Time.parse(job.item["failed_at"]) : job.item["failed_at"]
        end
      end

      attr_reader :job_class, :time_elapsed_since_failure, :error_class, :bucket_name, :job

      def initialize(args)
        @job                        = args.fetch(:job)
        @time_elapsed_since_failure = args.fetch(:time_elapsed_since_failure)
        @bucket_name                = args.fetch(:bucket_name)
        @job_class                  = args.fetch(:job_class, job.item["class"])
        @error_class                = args.fetch(:error_class, job.item["error_class"])
      end

      def ==(other)
        job_class == other.job_class &&
          time_elapsed_since_failure == other.time_elapsed_since_failure &&
          error_class                == other.error_class &&
          bucket_name                == other.bucket_name &&
          job_eql?(other.job)
      end
      alias eql? ==

      private

      attr_writer :job_class, :time_elapsed_since_failure, :error_class, :bucket_name, :job

      def job_eql?(other_job) # rubocop:disable Metrics/AbcSize
        job.jid == other_job.jid &&
          job.item        == other_job.item &&
          job.args        == other_job.args &&
          job.queue       == other_job.queue &&
          job.score       == other_job.score &&
          job.parent.name == other_job.parent.name &&
          job.parent.size == other_job.parent.size
      end
    end
  end
end
