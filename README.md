# iLoveVideoEditor Ruby SDK (High-Level Wrapper)

Official high-level Ruby SDK for iLoveVideoEditor.

## Installation

```ruby
gem 'ilovevideoeditor-sdk'
```

## Quick Start

```ruby
require 'ilovevideoeditor-sdk'

client = ILoveVideoEditor::Client.new(api_key: 'vf_live_xxx')

result = client.render(
  { name: 'Hello', layers: [...] },
  on_progress: ->(status, progress) { puts "#{status} — #{progress}%" }
)

puts result.download_url
```
