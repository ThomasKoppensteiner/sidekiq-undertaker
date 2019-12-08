# frozen_string_literal: true

require "spec_helper"

module Sidekiq
  module Undertaker
    describe Bucket do
      describe ".bucket_names" do
        let(:expected_bucket_names) { %w[1_hour 3_hours 1_day 3_days 1_week older] }

        it { expect(described_class.bucket_names).to eq expected_bucket_names }
      end

      describe ".for_elapsed_time" do
        let(:expectation) { %w[1_hour 3_hours 1_day 3_days 1_week older] }
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
