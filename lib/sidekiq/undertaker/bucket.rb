# frozen_string_literal: true

module Sidekiq
  module Undertaker
    class Bucket
      class << self
        def bucket_names
          %w[1_hour 3_hours 1_day 3_days 1_week older]
        end

        def for_elapsed_time(elapsed_time)
          return "1_hour"  if elapsed_time <= ONE_HOUR
          return "3_hours" if elapsed_time <= THREE_HOURS
          return "1_day"   if elapsed_time <= ONE_DAY
          return "3_days"  if elapsed_time <= THREE_DAYS
          return "1_week"  if elapsed_time <= ONE_WEEK

          "older"
        end

        ONE_HOUR    = 60 * 60 * 1
        THREE_HOURS = ONE_HOUR * 3
        ONE_DAY     = ONE_HOUR * 24
        THREE_DAYS  = ONE_DAY  * 3
        ONE_WEEK    = ONE_DAY  * 7
      end
    end
  end
end
