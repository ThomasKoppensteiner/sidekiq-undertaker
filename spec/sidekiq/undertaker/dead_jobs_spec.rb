# frozen_string_literal: true

require "spec_helper"

module Sidekiq
  module Undertaker
    describe DeadJob do
      let(:job) do
        build_job(
          "class"         => "HardWorkTask",
          "failed_at"     => Time.now,
          "error_class"   => "NoMethodError",
          "queue"         => "SomeQueue",
          "error_message" => "undefined method `pause` for HardWork:Class"
        )
      end

      describe "attributes" do
        let(:expected_attributes) do
          {
            job_class:                  "HardWorkTask",
            time_elapsed_since_failure: 9,
            error_class:                "NoMethodError",
            error_msg:                  "undefined method `pause` for H...",
            bucket_name:                "1_hour",
            job:                        job
          }
        end

        context "when all attributes are given" do
          let(:args) { expected_attributes }

          it { expect(described_class.new(args)).to have_attributes expected_attributes }
        end

        context "when some attributes are derived" do
          let(:args) do
            {
              time_elapsed_since_failure: 9,
              bucket_name:                "1_hour",
              job:                        job
            }
          end

          it do
            expect(
              described_class.new(args)
            ).to have_attributes expected_attributes
          end
        end
      end

      describe ".for_each" do
        let(:expected_dead_job) do
          described_class.new(
            job_class:                  "HardWorkTask",
            time_elapsed_since_failure: time_elapsed,
            error_class:                "NoMethodError",
            error_msg:                  "undefined method `pause` for H...",
            bucket_name:                "1_hour",
            job:                        killed_job
          )
        end

        let(:killed_job) do
          Sidekiq::DeadSet.new.find_job(job.jid)
        end

        let(:time_elapsed) { Time.now.to_i - job.item["failed_at"].to_i }

        before do
          Timecop.freeze

          kill_job(job)
        end

        after do
          Timecop.return
        end

        it "returns job with appropriate metadata filled" do
          cnt = 0
          described_class.for_each do |dead_job|
            # It returns only one dead_job
            cnt += 1
            expect(dead_job).to eql expected_dead_job
          end
          expect(cnt).to be 1
        end
      end
    end
  end
end
