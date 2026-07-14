Gem::Specification.new do |s|
  s.name        = 'ilovevideoeditor-sdk'
  s.version     = '1.0.1'
  s.summary     = 'Official Ruby SDK for the iLoveVideoEditor cloud video rendering API'
  s.description = 'Render videos programmatically with the iLoveVideoEditor cloud video API: submit JSON scenes or render templates with variables, queue render jobs, and download the resulting MP4/WebM. ' \
                  'Provides a high-level client with blocking renders, polling and progress callbacks, plus the full auto-generated OpenAPI client for every endpoint. ' \
                  'Requires Ruby 3.0 or later.'
  s.authors     = ['iLoveVideoEditor']
  s.email       = 'support@ilovevideoeditor.com'
  s.files       = Dir['lib/**/*.rb']
  s.require_paths = ['lib', 'lib/generated']
  s.homepage    = 'https://ilovevideoeditor.com/docs/sdks'
  s.license     = 'MIT'
  s.metadata    = {
    'homepage_uri' => 'https://ilovevideoeditor.com',
    'source_code_uri' => 'https://github.com/ilovevideoeditor/sdk-ruby',
    'documentation_uri' => 'https://ilovevideoeditor.com/docs',
    'changelog_uri' => 'https://github.com/ilovevideoeditor/sdk-ruby/blob/master/CHANGELOG.md',
    'bug_tracker_uri' => 'https://github.com/ilovevideoeditor/sdk-ruby/issues'
  }
  s.required_ruby_version = '>= 3.0'
  s.add_runtime_dependency 'typhoeus', '~> 1.0', '>= 1.0.1'
end
