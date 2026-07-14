# frozen_string_literal: true

# End-to-end tests for the Ruby SDK against a local Prism mock server.
#
# Run with:
#   ruby -I lib -I lib/generated test/e2e_test.rb
#
# Environment:
#   SDK_TEST_BASE_URL     (default http://127.0.0.1:4010)
#   SDK_TEST_API_KEY      (default test-key)
#   SDK_TEST_BEARER_TOKEN (default test-token)

require 'minitest/autorun'
require 'ilovevideoeditor-sdk'
require 'ilovevideoeditor/client'

BASE_URL = ENV.fetch('SDK_TEST_BASE_URL', 'http://127.0.0.1:4010')
API_KEY = ENV.fetch('SDK_TEST_API_KEY', 'test-key')
BEARER_TOKEN = ENV.fetch('SDK_TEST_BEARER_TOKEN', 'test-token')

VIDEO_JSON = {
  name: 'e2e-test',
  layers: [{ type: 'composition', width: 1920, height: 1080, fps: 30 }]
}.freeze

class E2ETest < Minitest::Test
  def setup
    ILoveVideoEditor.configure do |config|
      config.scheme = BASE_URL.start_with?('https') ? 'https' : 'http'
      config.host = BASE_URL
      config.api_key['x-api-key'] = API_KEY
      config.access_token = BEARER_TOKEN
    end
  end

  def test_health_check
    api = ILoveVideoEditor::HealthApi.new
    status = api.health_check
    assert_kind_of String, status.status
    refute_empty status.status
  end

  def test_list_templates_generated
    api = ILoveVideoEditor::TemplatesApi.new
    result = api.list_templates
    assert_kind_of Array, result.templates
  end

  def test_list_templates_wrapper
    client = ILoveVideoEditor::Client.new(api_key: API_KEY, base_url: BASE_URL)
    templates = client.list_templates
    assert_kind_of Array, templates
  end

  def test_queue_render
    api = ILoveVideoEditor::RenderApi.new
    body = ILoveVideoEditor::QueueRenderRequest.new(video_json: VIDEO_JSON)
    result = api.queue_render(body)
    refute_nil result.job_id
    refute_nil result.status
  end

  def test_estimate_render_cost
    api = ILoveVideoEditor::RenderApi.new
    body = ILoveVideoEditor::EstimateRenderCostRequest.new(video_json: VIDEO_JSON)
    estimate = api.estimate_render_cost(body)
    assert_kind_of Numeric, estimate.cost
    assert_kind_of Numeric, estimate.estimated_duration
  end

  def test_list_projects
    api = ILoveVideoEditor::ProjectsApi.new
    result = api.list_projects(page: 1, limit: 10)
    assert_kind_of Array, result.projects
    assert_kind_of Integer, result.total
    assert_kind_of Integer, result.page
  end
end
