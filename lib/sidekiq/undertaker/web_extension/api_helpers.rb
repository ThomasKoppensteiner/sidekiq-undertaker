# frozen_string_literal: true

require "sidekiq/undertaker/job_distributor"
require "sidekiq/undertaker/job_filter"

module Sidekiq
  module Undertaker
    module WebExtension
      module APIHelpers
        def show_filter
          store_request_params

          @dead_jobs    = Sidekiq::Undertaker::JobFilter.filter_dead_jobs(params)
          @distribution = Sidekiq::Undertaker::JobDistributor.new(@dead_jobs).group_by_job_class
          @total_dead   = @dead_jobs.size

          render_result("filter.erb")
        end

        def show_filter_by_job_class_bucket_name
          store_request_params

          @dead_jobs    = Sidekiq::Undertaker::JobFilter.filter_dead_jobs(params)
          @distribution = Sidekiq::Undertaker::JobDistributor.new(@dead_jobs).group_by_error_class
          @total_dead   = @dead_jobs.size

          render_result("filter_job_class.erb")
        end

        def show_undertaker_by_job_class_error_class_bucket_name
          store_request_params

          @dead_jobs = Sidekiq::Undertaker::JobFilter.filter_dead_jobs(params)

          # Display dead jobs as list
          @dead_jobs = @dead_jobs.map(&:job)

          @undertaker_path = "undertaker/morgue/#{@req_job_class}/#{@req_error_class}/#{@req_bucket_name}"

          # Pagination
          @total_dead   = @dead_jobs.size
          @current_page = (params[:page] || 1).to_i
          @count        = 50 # per page
          @dead_jobs    = @dead_jobs[((@current_page - 1) * @count), @count]

          # HINT: For making the pagination from sidekiq work, @total_size needs to be set
          #       https://github.com/mperham/sidekiq/blob/master/web/views/_paging.erb#L1
          @total_size = @total_dead

          # Remove unrelated arguments to allow _paginate url to be clean
          # Hack to continue to reuse sidekiq's _pagination template
          params.delete("job_class")
          params.delete("bucket_name")
          params.delete("error_class")

          render_result("morgue.erb")
        end

        def post_undertaker
          raise ::ArgumentError.new("Key missing") unless params["key"]

          params["key"].each do |key|
            job = Sidekiq::DeadSet.new.fetch(*parse_params(key)).first
            if job
              if params["retry"]
                job.retry
              elsif params["delete"]
                job.delete
              end
            end
          end

          redirect redirect_path(request)
        rescue ::ArgumentError
          bad_request
        end

        def post_undertaker_job_class_error_class_buckent_name_delete
          store_request_params
          @dead_jobs = Sidekiq::Undertaker::JobFilter.filter_dead_jobs(params)
          @dead_jobs.each do |dead_job|
            dead_job.job.delete
          end

          redirect redirect_path(request)
        end

        def post_undertaker_job_class_error_class_buckent_name_retry
          store_request_params

          @dead_jobs = Sidekiq::Undertaker::JobFilter.filter_dead_jobs(params)
          @dead_jobs.each do |dead_job|
            dead_job.job.retry
          end

          redirect redirect_path(request)
        end

        def post_import_jobs
          file = param["upload_file"]
          raise ::ArgumentError.new("The file is not a json") if file.nil? || file[:type] != "application/json"

          data = params['upload_file'][:tempfile].read
          dead_set = Sidekiq::DeadSet.new

          JSON.parse(data).each do |job|
            dead_set.kill(Sidekiq.dump_json(job))
          end
          redirect redirect_path(request)
        rescue
          bad_request
        end

        def render_result(template)
          render(:erb, File.read(File.join(view_path, template)))
        end

        def store_request_params
          @req_job_class   = params["job_class"]
          @req_bucket_name = params["bucket_name"]
          @req_error_class = params["error_class"]
        end

        def view_path
          File.join(File.expand_path(__dir__), "../../../../web/views")
        end

        def redirect_path(request)
          path = request.referer ? URI.parse(request.referer).path : request.path
          path.gsub("/delete", "").gsub("/retry", "")
        end

        def bad_request
          [400, { "Content-Type" => "text/plain" }, ["Bad Request"]]
        end
      end
    end
  end
end
