# frozen_string_literal: true

require "spec_helper"

require "sidekiq/api"
require "sidekiq/web"
require "sinatra"
require "rack/test"

module Sidekiq
  # rubocop:disable Metrics/ModuleLength
  module Cleaner
    describe WebExtension, type: :controller do
      include Rack::Test::Methods

      let(:app) { Sidekiq::Web }
      let(:job_refs) { [] }

      let(:jid1) { "4416aa76eb8cf03f56a49220" }
      let(:jid2) { "34e79a46b1956d3a1180767b" }
      let(:jid3) { "8d08674fce759ac75d1a6e75" }
      let(:jid4) { "bfa4a272cdcac8bfac7b9f1a" }

      let(:default_job_opts) do
        {
          "class"         => "HardWorker",
          "args"          => ["asdf", 1234],
          "queue"         => "foo",
          "error_message" => "Some fake message",
          "error_class"   => "RuntimeError",
          "retry_count"   => 0,
          "failed_at"     => Time.now.utc
        }
      end

      before do
        Timecop.freeze(Time.new(2018, 12, 16, 20, 57))

        job_refs.push add_dead("jid" => jid1)
        job_refs.push add_dead("jid" => jid2)
        job_refs.push add_dead("jid" => jid3, "error_class" => "NoMethodError")
        job_refs.push add_dead("jid" => jid4, "class" => "HardWorker1", "error_class" => "NoMethodError")
      end

      after { Timecop.return }

      def add_dead(opts = {})
        opts = default_job_opts.merge!(opts)

        job = build_job(opts)
        killed_job = kill_job(job)

        "#{killed_job.score}-#{job.jid}"
      end

      describe "show" do
        shared_examples "a cleaner page" do
          it "the displayed page is correct" do
            subject

            expect(last_response.status).to eq 200
            verify { last_response.body }
          end
        end

        context "when /cleaner is called" do
          subject { get "/cleaner" }

          it_behaves_like "a cleaner page"
        end

        context "when /cleaner/:job_class/:bucket_name is called" do
          subject { get "/cleaner/HardWorker/1_hour" }

          it_behaves_like "a cleaner page"
        end

        context "when /cleaner/:job_class/:bucket_name with live-poll is called" do
          subject { get "/cleaner/HardWorker/1_hour?poll=true" }

          it_behaves_like "a cleaner page"
        end

        context "when /cleaner/:job_class/:error_class/:bucket_name is called" do
          context "with specific job-class and a specific error" do
            subject { get "/cleaner/HardWorker/RuntimeError/1_hour" }

            it_behaves_like "a cleaner page"
          end

          context "with all failures and errors" do
            subject { get "/cleaner/AllErrors/AllErrors/total_failures" }

            it_behaves_like "a cleaner page"
          end
        end
      end

      describe "delete" do
        context "when job-class, error and bucket are given" do
          subject { post "/cleaner/HardWorker/RuntimeError/1_hour/delete" }

          let(:expected_redirect_url) { "http://example.org/cleaner/HardWorker/RuntimeError/1_hour" }

          let(:params) { { "job_class" => "HardWorker", "error_class" => "RuntimeError", "bucket_name" => "1_hour" } }
          let(:dead_jobs_set) { [dead_job1, dead_job2] }
          let(:dead_job1) { Sidekiq::Cleaner::DeadJob.to_dead_job(Sidekiq::DeadSet.new.find_job(jid1)) }
          let(:dead_job2) { Sidekiq::Cleaner::DeadJob.to_dead_job(Sidekiq::DeadSet.new.find_job(jid2)) }

          before do
            allow(Sidekiq::Cleaner::JobFilter).to receive(:filter_dead_jobs).with(params)
                                                                            .and_return(dead_jobs_set)
          end

          it "deletes the dead jobs" do
            expect(dead_job1.job).to receive(:delete).and_call_original
            expect(dead_job2.job).to receive(:delete).and_call_original
            subject
          end

          it "reduces the DeadSet" do
            expect { subject }.to change { Sidekiq::DeadSet.new.size }.from(4).to(2)
          end

          it "redirects to /cleaner/HardWorker/RuntimeError/1_hour after the delete" do
            subject
            expect(last_response.status).to eq 302

            # Redirect
            follow_redirect!
            expect(last_request.url).to eq expected_redirect_url
            expect(last_response.status).to eq 200
          end
        end

        context "when referer given" do
          subject do
            post("/cleaner",
                 "key[]=#{job_refs[0]}&delete=Delete",
                 "HTTP_REFERER" => "/cleaner/AllErrors/AllErrors/total_failures")
          end

          it "redirects back to referer after delete" do
            subject
            expect(last_response.header["Location"]).to include "/cleaner/AllErrors/AllErrors/total_failures"
          end
        end

        context "when /cleaner is called" do
          context "when a key is given" do
            subject { post "/cleaner", "key[]=#{job_refs[0]}&delete=Delete" }

            it "deletes specific dead job now" do
              expect { subject }.to change { Sidekiq::DeadSet.new.size }.from(4).to(3)
            end
          end

          context "when a key is missing" do
            subject { post "/cleaner" }

            it "returns 400 Bad Request" do
              subject
              expect(last_response.status).to eq 400
            end
          end
        end
      end

      describe "retry" do
        context "when job class, error and bucket are given" do
          subject { post "/cleaner/HardWorker/RuntimeError/1_hour/retry" }

          let(:expected_redirect_url) { "http://example.org/cleaner/HardWorker/RuntimeError/1_hour" }

          let(:params) { { "job_class" => "HardWorker", "error_class" => "RuntimeError", "bucket_name" => "1_hour" } }
          let(:dead_jobs_set) { [dead_job1, dead_job2] }
          let(:dead_job1) { Sidekiq::Cleaner::DeadJob.to_dead_job(Sidekiq::DeadSet.new.find_job(jid1)) }
          let(:dead_job2) { Sidekiq::Cleaner::DeadJob.to_dead_job(Sidekiq::DeadSet.new.find_job(jid2)) }

          before do
            allow(Sidekiq::Cleaner::JobFilter).to receive(:filter_dead_jobs).with(params)
                                                                            .and_return(dead_jobs_set)
          end

          it "retries the dead jobs" do
            expect(dead_job1.job).to receive(:retry).and_call_original
            expect(dead_job2.job).to receive(:retry).and_call_original
            subject
          end

          it "reduces DeadSet" do
            expect { subject }.to change { Sidekiq::DeadSet.new.size }.from(4).to(2)
          end

          it "redirects to /cleaner/HardWorker/RuntimeError/1_hour" do
            subject
            expect(last_response.status).to eq 302

            # Redirect
            follow_redirect!
            expect(last_request.url).to eq expected_redirect_url
            expect(last_response.status).to eq 200
          end
        end

        context "when /cleaner is called" do
          context "when a key is given" do
            subject { post "/cleaner", "key[]=#{job_refs[0]}&retry=Retry+Now" }

            it "reduces DeadSet" do
              expect { subject }.to change { Sidekiq::DeadSet.new.size }.from(4).to(3)
            end
          end

          context "when a key is missing" do
            subject { post "/cleaner" }

            it "returns 400 Bad Request" do
              subject
              expect(last_response.status).to eq 400
            end
          end
        end
      end

      describe "specific jobs" do
        let(:dead_job) { Sidekiq::DeadSet.new.find_job(jid1) }

        before do
          score, jid = job_refs[0].split("-")

          dead_set = instance_double(Sidekiq::DeadSet)

          allow(dead_set).to receive(:fetch)
            .with(score.to_f, jid)
            .and_return([dead_job])

          allow(Sidekiq::DeadSet).to receive(:new).and_return(dead_set)
        end

        it "retries specific dead job now" do
          expect(dead_job).to receive(:retry)
          post "/cleaner", "key[]=#{job_refs[0]}&retry=Retry+Now"
        end

        it "redirects on specific retry post" do
          post("/cleaner",
               "key[]=#{job_refs[0]}&retry=Retry+Now",
               "HTTP_REFERER" => "/cleaner/AllErrors/AllErrors/total_failures")
          expect(last_response.header["Location"]).to include("/cleaner/AllErrors/AllErrors/total_failures")
        end
      end
    end
  end
  # rubocop:enable Metrics/ModuleLength
end
