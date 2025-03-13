# frozen_string_literal: true

require "sidekiq/undertaker/job_distributor"
require "sidekiq/undertaker/job_filter"
require "base64"
require "json"
require "zip"

module Sidekiq
  module Undertaker
    module WebExtension
      # rubocop:disable Metrics/ModuleLength
      module APIHelpers
        EXPORT_CHUNK_SIZE = 2000

        def show_filter
          store_request_params

          @dead_jobs    = Sidekiq::Undertaker::JobFilter.filter_dead_jobs(filter_params)
          @distribution = Sidekiq::Undertaker::JobDistributor.new(@dead_jobs).group_by_job_class
          @total_dead   = @dead_jobs.size

          render_result("filter.erb")
        end

        def show_filter_by_job_class_bucket_name
          store_request_params

          @dead_jobs    = Sidekiq::Undertaker::JobFilter.filter_dead_jobs(filter_params)
          @distribution = Sidekiq::Undertaker::JobDistributor.new(@dead_jobs).group_by_error_class
          @total_dead   = @dead_jobs.size

          render_result("filter_job_class.erb")
        end

        def show_filter_by_job_class_error_class_bucket_name
          store_request_params

          @dead_jobs    = Sidekiq::Undertaker::JobFilter.filter_dead_jobs(filter_params)
          @distribution = Sidekiq::Undertaker::JobDistributor.new(@dead_jobs).group_by_error_msg
          @total_dead   = @dead_jobs.size

          render_result("filter_job_class_error_class.erb")
        end

        def show_undertaker_by_job_class_error_class_error_msg_bucket_name
          store_request_params

          @dead_jobs = Sidekiq::Undertaker::JobFilter.filter_dead_jobs(filter_params)

          # Display dead jobs as list
          @dead_jobs = @dead_jobs.map(&:job)

          @undertaker_path = "undertaker/morgue/#{@req_job_class}/#{@req_error_class}/#{@req_bucket_name}"

          # Pagination
          @total_dead   = @dead_jobs.size
          @current_page = (url_params("page") || 1).to_i
          @count        = 50 # per page
          @dead_jobs    = @dead_jobs[((@current_page - 1) * @count), @count]

          # HINT: For making the pagination from sidekiq work, @total_size needs to be set
          #       https://github.com/mperham/sidekiq/blob/master/web/views/_paging.erb#L1
          @total_size = @total_dead

          # Remove unrelated arguments to allow _paginate url to be clean
          # Hack to continue to reuse sidekiq's _pagination template
          # FIXME: https://github.com/sidekiq/sidekiq/blob/main/lib/sidekiq/web/action.rb#L64-L67
          # params.delete("job_class")
          # params.delete("bucket_name")
          # params.delete("error_class")
          # params.delete("error_msg")

          render_result("morgue.erb")
        end

        def post_undertaker
          raise ::ArgumentError.new("Key missing") unless url_params("key")

          jobs = url_params("key").map { |k| Sidekiq::DeadSet.new.fetch(*parse_key(k)).first }.compact

          handle_selected_jobs jobs
        rescue ::ArgumentError
          bad_request
        end

        def handle_selected_jobs(jobs)
          return send_data(*prepare_data(jobs.map(&:item), EXPORT_CHUNK_SIZE)) if url_params("export")

          if url_params("retry")
            jobs.each(&:retry)
          elsif url_params("delete")
            jobs.each(&:delete)
          end

          redirect redirect_path(request)
        end

        def post_undertaker_job_class_error_class_error_msg_bucket_name_delete
          store_request_params
          @dead_jobs = Sidekiq::Undertaker::JobFilter.filter_dead_jobs(filter_params)
          @dead_jobs.each do |dead_job|
            dead_job.job.delete
          end

          redirect redirect_path(request)
        end

        def post_undertaker_job_class_error_class_error_msg_bucket_name_retry
          store_request_params

          @dead_jobs = Sidekiq::Undertaker::JobFilter.filter_dead_jobs(filter_params)
          @dead_jobs.each do |dead_job|
            dead_job.job.retry
          end

          redirect redirect_path(request)
        end

        def post_undertaker_job_class_error_class_error_msg_bucket_name_export
          store_request_params
          @dead_jobs = Sidekiq::Undertaker::JobFilter.filter_dead_jobs(filter_params)
          send_data(*prepare_data(@dead_jobs.map { |j| j.job.item }, EXPORT_CHUNK_SIZE))
        end

        def post_import_jobs
          file = url_params("upload_file")
          raise ::ArgumentError.new("The file is not a json") if file.nil? || file[:type] != "application/json"

          data = url_params("upload_file")[:tempfile].read
          dead_set = Sidekiq::DeadSet.new

          JSON.parse(data).each do |job|
            dead_set.kill(Sidekiq.dump_json(job))
          end
          redirect redirect_path(request)
        rescue StandardError
          bad_request
        end

        def render_result(template)
          render(:erb, File.read(File.join(view_path, template)))
        end

        def store_request_params
          @req_bucket_name = parsed_route_params(:bucket_name)
          @req_error_class = parsed_route_params(:error_class)
          @req_error_msg   = parsed_route_params(:error_msg)
          @req_job_class   = parsed_route_params(:job_class)
        end

        def filter_params
          {
            "bucket_name" => parsed_route_params(:bucket_name),
            "error_class" => parsed_route_params(:error_class),
            "error_msg"   => parsed_route_params(:error_msg),
            "job_class"   => parsed_route_params(:job_class)
          }
        end

        def parsed_route_params(key)
          if key == :error_msg
            msg = route_params(key)
            msg = Base64.urlsafe_decode64(msg) if !msg.nil? && msg != "all"
            msg
          else
            route_params(key)
          end
        end

        def view_path
          File.join(File.expand_path(__dir__), "../../../../web/views")
        end

        def redirect_path(request)
          path = request.referer ? URI.parse(request.referer).path : request.path
          path.gsub("/delete", "").gsub("/retry", "").gsub("/export", "")
        end

        def prepare_data(data, chunk_size)
          filename = Time.now.strftime("%Y-%m-%d_%H-%M").to_s
          return [data.to_json, "application/json", "#{filename}.json"] if data.length <= chunk_size

          filename = "#{@req_job_class}_#{filename}"
          zip = Zip::OutputStream.write_buffer do |file|
            data.each_slice(chunk_size).with_index do |chunk, index|
              file.put_next_entry("#{filename}_part-#{index + 1}.json")
              file.write chunk.to_json
            end
          end

          [zip.string, "application/zip", "#{filename}.zip"]
        end

        def send_data(data, content_type = "text/plain", file_name = "attachment.txt")
          [
            200,
            {
              "Content-Type"        => content_type,
              "Content-Disposition" => "attachment; filename=\"#{file_name}\""
            },
            [data]
          ]
        end

        def bad_request
          [400, { "Content-Type" => "text/plain" }, ["Bad Request"]]
        end
      end
      # rubocop:enable Metrics/ModuleLength
    end
  end
end
