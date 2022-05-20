# frozen_string_literal: true

require "spec_helper"

module Sidekiq
  # rubocop:disable Metrics/ModuleLength
  module Undertaker
    describe JobDistributor do
      let(:job1) do
        instance_double(Sidekiq::JobRecord, item: {
                          "class"         => "A",
                          "failed_at"     => 1,
                          "error_class"   => "E1",
                          "error_message" => "M1"
                        })
      end
      let(:job2) do
        instance_double(Sidekiq::JobRecord, item: {
                          "class"         => "A",
                          "failed_at"     => 1,
                          "error_class"   => "E1",
                          "error_message" => "M1"
                        })
      end
      let(:job3) do
        instance_double(Sidekiq::JobRecord, item: {
                          "class"         => "B",
                          "failed_at"     => 1,
                          "error_class"   => "E1",
                          "error_message" => "M2"
                        })
      end
      let(:job4) do
        instance_double(Sidekiq::JobRecord, item: {
                          "class"         => "B",
                          "failed_at"     => 1,
                          "error_class"   => "E2",
                          "error_message" => "M1"
                        })
      end

      let(:dead_job1) do
        DeadJob.new(
          job:                        job1, # 'A', 'E1', 'M1'
          time_elapsed_since_failure: 10,
          bucket_name:                "1_hour"
        )
      end

      let(:dead_job2) do
        DeadJob.new(
          job:                        job2, # 'A', 'E1', 'M1'
          time_elapsed_since_failure: 10 + (60 * 60),
          bucket_name:                "3_hours"
        )
      end
      let(:dead_job3) do
        DeadJob.new(
          job:                        job3, # 'B', 'E1', 'M2'
          time_elapsed_since_failure: 10 + (60 * 60),
          bucket_name:                "3_hours"
        )
      end
      let(:dead_job4) do
        DeadJob.new(
          job:                        job4, # 'B', 'E2', 'M1'
          time_elapsed_since_failure: 10 + (60 * 60 * 24),
          bucket_name:                "1_day"
        )
      end

      let(:dead_jobs) { [dead_job1, dead_job2, dead_job3, dead_job4] }

      # rubocop:disable Layout/LineLength
      describe "#group_by_job_class" do
        subject(:distribution) { described_class.new(dead_jobs).group_by_job_class }

        let(:expected_distribution) do
          [
            ["all", { "1_hour" => 1, "3_hours" => 2, "1_day" => 1, "3_days" => 0, "1_week" => 0, "older" => 0, "total_dead" => 4 }],
            ["B",   { "1_hour" => 0, "3_hours" => 1, "1_day" => 1, "3_days" => 0, "1_week" => 0, "older" => 0, "total_dead" => 2 }],
            ["A",   { "1_hour" => 1, "3_hours" => 1, "1_day" => 0, "3_days" => 0, "1_week" => 0, "older" => 0, "total_dead" => 2 }]
          ]
        end

        it "distributes the dead jobs into buckets and groups them by job_class" do
          expect(distribution).to eq expected_distribution
        end
      end

      describe "#group_by_error_class" do
        subject(:distribution) { described_class.new(dead_jobs).group_by_error_class }

        let(:expected_distribution) do
          [
            ["all", { "1_hour" => 1, "3_hours" => 2, "1_day" => 1,  "3_days" => 0, "1_week" => 0, "older" => 0, "total_dead" => 4 }],
            ["E1",  { "1_hour" => 1, "3_hours" => 2, "1_day" => 0,  "3_days" => 0, "1_week" => 0, "older" => 0, "total_dead" => 3 }],
            ["E2",  { "1_hour" => 0, "3_hours" => 0, "1_day" => 1,  "3_days" => 0, "1_week" => 0, "older" => 0, "total_dead" => 1 }]
          ]
        end

        it "distributes the dead jobs into buckets and groups them by error_class" do
          expect(distribution).to eq expected_distribution
        end
      end

      describe "#group_by_error_msg" do
        subject(:distribution) { described_class.new(dead_jobs).group_by_error_msg }

        let(:expected_distribution) do
          [
            ["all", { "1_hour" => 1, "3_hours" => 2, "1_day" => 1,  "3_days" => 0, "1_week" => 0, "older" => 0, "total_dead" => 4 }],
            ["M1",  { "1_hour" => 1, "3_hours" => 1, "1_day" => 1,  "3_days" => 0, "1_week" => 0, "older" => 0, "total_dead" => 3 }],
            ["M2",  { "1_hour" => 0, "3_hours" => 1, "1_day" => 0,  "3_days" => 0, "1_week" => 0, "older" => 0, "total_dead" => 1 }]
          ]
        end

        it "distributes the dead jobs into buckets and groups them by error_msg" do
          expect(distribution).to eq expected_distribution
        end
      end
      # rubocop:enable Layout/LineLength
    end
  end
  # rubocop:enable Metrics/ModuleLength
end
