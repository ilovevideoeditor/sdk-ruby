# ilovevideoeditor-sdk

Official Ruby SDK for iLoveVideoEditor — render videos programmatically with a cloud video API.

iLoveVideoEditor is a cloud video rendering API: submit a JSON scene description (`VideoJSON`) or a template with variables, queue a render job, and download the resulting MP4/WebM when it finishes. This gem is the official Ruby client — a high-level wrapper with blocking renders, polling and progress callbacks, plus the full auto-generated OpenAPI client for every endpoint.

[![Gem Version](https://img.shields.io/gem/v/ilovevideoeditor-sdk.svg)](https://rubygems.org/gems/ilovevideoeditor-sdk) [![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE) [![Docs](https://img.shields.io/badge/docs-ilovevideoeditor.com-blue)](https://ilovevideoeditor.com/docs/sdks)
- API reference: [OpenAPI spec](https://ilovevideoeditor.com/docs/api/openapi.yaml) · [Postman collection](https://ilovevideoeditor.com/docs/api/postman-collection.json)

## Features

- **High-level `ILoveVideoEditor::Client`** — one-call `render` that queues a job, polls until completion, and returns a `RenderResult` (`job_id`, `status`, normalized `progress` percent, `url`, `download_url`, `error`, timestamps)
- **Progress callbacks & timeouts** — `on_progress` lambda plus configurable `poll_interval` and `max_wait` (raises `Timeout::Error` when exceeded)
- **Template rendering** — list and fetch templates, render them with variables (`TemplatesApi#render_template`)
- **Full generated OpenAPI client** — `RenderApi`, `TemplatesApi`, `ProjectsApi`, `AssetsApi`, `WebhooksApi`, `WorkflowsApi`, `ToolsApi`, `ApiKeysApi`, `BillingApi`, `RenditionsApi`, `IntegrationsApi`, `HealthApi`
- **Asset uploads** — request signed upload URLs and upload media to use as render inputs
- **Webhooks** — manage subscriptions for render lifecycle events (`render.completed`, `render.failed`)
- **Cost estimates** — estimate render cost and duration before queueing (`RenderApi#estimate_render_cost`)
- **Two auth modes** — API key (`x-api-key`) for render pipeline and tool endpoints, Bearer JWT for user-scoped project, asset, billing and webhook endpoints
- **Ruby ≥ 3.0**, fast [typhoeus](https://github.com/typhoeus/typhoeus) (libcurl) HTTP backend

## Installation

```bash
gem install ilovevideoeditor-sdk
```

Or with Bundler:

```ruby
gem "ilovevideoeditor-sdk", "~> 1.0"
```

Requires Ruby 3.0 or later.

## Quick start

```ruby
require 'ilovevideoeditor-sdk'
require 'ilovevideoeditor/client'

client = ILoveVideoEditor::Client.new(api_key: ENV.fetch('ILOVEVIDEOEDITOR_API_KEY'))

# Submit a VideoJSON scene and block until the render finishes.
result = client.render(
  {
    name: 'hello-world',
    layers: [{ type: 'composition', width: 1920, height: 1080, fps: 30 }],
  },
  on_progress: ->(status, percent) { puts "#{status} — #{percent.round}%" }
)

puts result.status        # => "completed"
puts result.download_url  # => signed URL of the rendered MP4
```

Render a template with variables:

```ruby
api = ILoveVideoEditor::TemplatesApi.new

queued = api.render_template(
  'template-id',
  ILoveVideoEditor::RenderTemplateRequest.new(variables: { headline: 'Hello!' })
)
puts queued.job_id
```

Check on a job you queued earlier:

```ruby
status = client.get_render('job-id')
url = client.refresh_url('job-id') if status.status == 'completed'
```

## Authentication

Create an API key in your iLoveVideoEditor dashboard — keys are prefixed `vf_live_`. Keep the key out of source control; read it from an environment variable:

```bash
export ILOVEVIDEOEDITOR_API_KEY=vf_live_...
```

```ruby
client = ILoveVideoEditor::Client.new(api_key: ENV.fetch('ILOVEVIDEOEDITOR_API_KEY'))
```

For user-scoped endpoints (projects, assets, billing, webhooks) that require a Bearer token, configure the generated client directly:

```ruby
ILoveVideoEditor.configure do |config|
  config.access_token = ENV.fetch('ILOVEVIDEOEDITOR_JWT')
end
```

## Documentation

- Docs: https://ilovevideoeditor.com/docs
- SDK guides: https://ilovevideoeditor.com/docs/sdks
- RubyGems page: https://rubygems.org/gems/ilovevideoeditor-sdk

## Other official SDKs

- **Node.js / TypeScript**: [@ilovevideoeditor/sdk-node](https://www.npmjs.com/package/@ilovevideoeditor/sdk-node) — [repo](https://github.com/ilovevideoeditor/sdk-node)
- **Python**: [ilovevideoeditor-sdk](https://pypi.org/project/ilovevideoeditor-sdk/) — [repo](https://github.com/ilovevideoeditor/sdk-python)
- **PHP**: [ilovevideoeditor/sdk](https://packagist.org/packages/ilovevideoeditor/sdk) — [repo](https://github.com/ilovevideoeditor/sdk-php)
- **Go**: [github.com/ilovevideoeditor/sdk-go](https://pkg.go.dev/github.com/ilovevideoeditor/sdk-go) — [repo](https://github.com/ilovevideoeditor/sdk-go)

## License

MIT — see [LICENSE](LICENSE).
