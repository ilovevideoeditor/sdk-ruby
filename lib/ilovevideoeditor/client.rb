require 'ilovevideoeditor-sdk'

module ILoveVideoEditor
  # High-level iLoveVideoEditor client with polling and friendly method names.
  #
  # Usage:
  #   client = ILoveVideoEditor::Client.new(api_key: 'vf_live_xxx')
  #   result = client.render({ name: 'Hello', layers: [...] })
  #   puts result.download_url
  class Client
    RenderResult = Struct.new(
      :job_id, :status, :progress, :url, :download_url,
      :error, :created_at, :completed_at,
      keyword_init: true
    )

    def initialize(api_key:, base_url: 'https://api.ilovevideoeditor.com')
      raise ArgumentError, 'api_key is required' if api_key.nil? || api_key.empty?

      ILoveVideoEditor.configure do |config|
        config.host = base_url
        config.api_key['x-api-key'] = api_key
      end

      @render_api = ILoveVideoEditor::RenderApi.new
      @templates_api = ILoveVideoEditor::TemplatesApi.new
    end

    # Normalize the API progress payload ({done, total, percent}) to a percent number.
    def self.progress_percent(progress)
      return 0.0 if progress.nil?
      return progress.to_f if progress.is_a?(Numeric)

      progress.respond_to?(:percent) && progress.percent ? progress.percent.to_f : 0.0
    end

    # Submit a VideoJSON payload and block until the render finishes.
    def render(video_json, poll_interval: 2, max_wait: 300, on_progress: nil)
      body = ILoveVideoEditor::QueueRenderRequest.new(video_json: video_json)
      queued = @render_api.queue_render(body)
      job_id = queued.job_id

      deadline = Time.now + max_wait
      while Time.now < deadline
        status = @render_api.get_render_status(job_id)
        progress = self.class.progress_percent(status.progress)
        on_progress&.call(status.status, progress)

        if status.status == 'completed'
          refresh = @render_api.refresh_render_url(job_id)
          return RenderResult.new(
            job_id: job_id,
            status: status.status,
            progress: progress,
            url: status.url,
            download_url: refresh.download_url,
            error: status.error,
            created_at: status.created_at,
            completed_at: status.completed_at
          )
        end

        if status.status == 'failed'
          return RenderResult.new(
            job_id: job_id,
            status: status.status,
            progress: progress,
            error: status.error,
            created_at: status.created_at,
            completed_at: status.completed_at
          )
        end

        sleep(poll_interval)
      end

      raise Timeout::Error, "Render #{job_id} did not complete within #{max_wait}s"
    end

    def get_render(job_id)
      status = @render_api.get_render_status(job_id)
      RenderResult.new(
        job_id: status.job_id,
        status: status.status,
        progress: self.class.progress_percent(status.progress),
        url: status.url,
        error: status.error,
        created_at: status.created_at,
        completed_at: status.completed_at
      )
    end

    def refresh_url(job_id)
      result = @render_api.refresh_render_url(job_id)
      result.download_url
    end

    def list_templates
      @templates_api.list_templates.templates
    end

    def get_template(id)
      @templates_api.get_template(id).template
    end
  end
end
