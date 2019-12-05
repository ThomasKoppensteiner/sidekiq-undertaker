# frozen_string_literal: true

require "spec_helper"

module Sidekiq
  module Undertaker
    describe Bucket do
      describe ".buckets" do
        let(:expected_buckets) do
          [["1_hour", 3600], ["3_hours", 10800], ["1_day", 86400], ["3_days", 259200], ["7_days", 604800]]
        end

        it "interpolates" do
          expect(described_class.buckets).to eql expected_buckets
        end
      end

      describe ".for_elapsed_time" do
        let(:expectation) { %w[1_hour 3_hours 1_day 3_days 7_days 7_days] }
        let(:elapsed_times) { [1, 3601, 10801, 86401, 259201, 604801] }

        it "maps elapsed_time to bucket name" do
          elapsed_times.each_with_index do |elapsed_time, index|
            expect(described_class.for_elapsed_time(elapsed_time)).to eq expectation[index]
          end
        end
      end
    end
  end
end
