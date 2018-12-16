# frozen_string_literal: true

require "spec_helper"

module Sidekiq
  module Cleaner
    describe JobFilter do
      describe ".filter_dead_jobs" do
        let(:job1) do
          instance_double(Sidekiq::Job, item: {
                            "class"       => "HardWorkTask",
                            "failed_at"   => Time.now.to_i - 5 * 60,
                            "error_class" => "NoMethodError"
                          })
        end

        let(:job2) do
          instance_double(Sidekiq::Job, item: {
                            "class"       => "HardWorkTask",
                            "failed_at"   => Time.now.to_i - 2 * 60 * 60,
                            "error_class" => "RandomError"
                          })
        end

        let(:job3) do
          instance_double(Sidekiq::Job, item: {
                            "class"       => "LazyWorkTask",
                            "failed_at"   => Time.now.to_i - 2 * 60 * 60,
                            "error_class" => "NoMethodError"
                          })
        end

        before do
          Timecop.freeze

          dead_set = instance_double(Sidekiq::DeadSet)

          allow(dead_set).to receive(:each)
            .and_yield(job1)
            .and_yield(job2)
            .and_yield(job3)

          allow(Sidekiq::DeadSet).to receive(:new).and_return(dead_set)
        end

        after { Timecop.return }

        context "when the job_class filter is given" do
          subject(:dead_jobs) { described_class.filter_dead_jobs("job_class" => "HardWorkTask") }

          it "filters jobs based on job_class" do
            dead_jobs.each do |dead_job|
              expect(dead_job.job_class).to eq "HardWorkTask"
            end
          end

          it { expect(dead_jobs.size).to eq 2 }
        end

        context "when the job_class and bucket_name filters are given" do
          subject(:dead_jobs) do
            described_class.filter_dead_jobs("job_class"   => "HardWorkTask",
                                             "bucket_name" => "3_hours")
          end

          it "filters based on multiple filter attributes" do
            dead_jobs.each do |dead_job|
              expect(dead_job.job_class).to eq "HardWorkTask"
              expect(dead_job.bucket_name).to eq "3_hours"
            end
          end

          it { expect(dead_jobs.size).to eq 1 }
        end

        context "when the error_class filter is given" do
          subject(:dead_jobs) { described_class.filter_dead_jobs("error_class" => "NoMethodError") }

          it "filters jobs based on error_class" do
            dead_jobs.each do |dead_job|
              expect(dead_job.error_class).to eq "NoMethodError"
            end
          end
          it { expect(dead_jobs.size).to eq 2 }
        end

        context "when no filters are applied" do
          subject(:dead_jobs) { described_class.filter_dead_jobs }

          it { expect(dead_jobs.size).to eq 3 }
        end

        context "when all filters are nil" do
          subject(:dead_jobs) do
            described_class.filter_dead_jobs("job_class"   => nil,
                                             "bucket_name" => nil,
                                             "error_class" => nil)
          end

          it { expect(dead_jobs.size).to eq 3 }
        end
      end
    end
  end
end
