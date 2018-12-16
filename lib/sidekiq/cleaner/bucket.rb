# frozen_string_literal: true

module Sidekiq
  module Cleaner
    class Bucket
      class << self
        def bucket_names
          %w[1_hour 3_hours 1_day 3_days 7_days]
        end

        def bucket_seconds
          [60 * 60 * 1, 60 * 60 * 3, 60 * 60 * 24, 60 * 60 * 24 * 3, 60 * 60 * 24 * 7]
        end

        def buckets
          bucket_names.zip bucket_seconds
        end

        def for_elapsed_time(elapsed_time)
          buckets.each do |bucket_name, seconds|
            return bucket_name if elapsed_time <= seconds
          end

          "7_days"
        end
      end
    end
  end
end
