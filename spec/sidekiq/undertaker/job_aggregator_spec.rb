# frozen_string_literal: true

require "spec_helper"

module Sidekiq
  module Undertaker
    describe JobAggregator do
      describe "#group_by" do
        let(:job1) do
          instance_double(Sidekiq::Job, item: {
                            "class"       => "A",
                            "failed_at"   => 1,
                            "error_class" => "E1"
                          })
        end
        let(:job2) do
          instance_double(Sidekiq::Job, item: {
                            "class"       => "A",
                            "failed_at"   => 1,
                            "error_class" => "E1"
                          })
        end
        let(:job3) do
          instance_double(Sidekiq::Job, item: {
                            "class"       => "B",
                            "failed_at"   => 1,
                            "error_class" => "E1"
                          })
        end
        let(:job4) do
          instance_double(Sidekiq::Job, item: {
                            "class"       => "B",
                            "failed_at"   => 1,
                            "error_class" => "E2"
                          })
        end

        let(:dead_job1) do
          DeadJob.new(
            job:                        job1, # 'A', 'E1'
            time_elapsed_since_failure: 10,
            bucket_name:                "1_hour"
          )
        end

        let(:dead_job2) do
          DeadJob.new(
            job:                        job2, # 'A', 'E1'
            time_elapsed_since_failure: 10 + 60 * 60,
            bucket_name:                "3_hours"
          )
        end
        let(:dead_job3) do
          DeadJob.new(
            job:                        job3, # 'B', 'E1'
            time_elapsed_since_failure: 10 + 60 * 60,
            bucket_name:                "3_hours"
          )
        end
        let(:dead_job4) do
          DeadJob.new(
            job:                        job4, # 'B', 'E2'
            time_elapsed_since_failure: 10 + 60 * 60 * 24,
            bucket_name:                "1_day"
          )
        end

        let(:dead_jobs) { [dead_job1, dead_job2, dead_job3, dead_job4] }

        context "when the jobs are grouped by job_class" do
          subject(:distribution) { described_class.new(dead_jobs).group_by_job_class }

          let(:expected_distribution) do
            [
              ["AllErrors", { "1_hour" => 1, "3_hours" => 2, "1_day" => 1, "total_failures" => 4 }],
              ["B",         { "3_hours" => 1, "1_day" => 1, "total_failures" => 2 }],
              ["A",         { "1_hour" => 1, "3_hours" => 1, "total_failures" => 2 }]
            ]
          end

          it "groups by job_class" do
            expect(distribution).to eq expected_distribution
          end
        end

        context "when the jobs are grouped by error_class" do
          subject(:distribution) { described_class.new(dead_jobs).group_by_error_class }

          let(:expected_distribution) do
            [
              ["AllErrors", { "1_hour" => 1, "3_hours" => 2, "1_day" => 1, "total_failures" => 4 }],
              ["E1",        { "1_hour" => 1, "3_hours" => 2, "total_failures" => 3 }],
              ["E2",        { "1_day" => 1, "total_failures" => 1 }]
            ]
          end

          it "groups by job_class" do
            expect(distribution).to eq expected_distribution
          end
        end
      end
    end
  end
end
