Gem::Specification.new do |s|
  s.name        = 'ilovevideoeditor-sdk'
  s.version     = '1.0.0'
  s.summary     = 'Official Ruby SDK for iLoveVideoEditor'
  s.description = 'High-level wrapper over the auto-generated iLoveVideoEditor OpenAPI client'
  s.authors     = ['iLoveVideoEditor']
  s.email       = 'support@ilovevideoeditor.com'
  s.files       = Dir['lib/**/*.rb']
  s.require_paths = ['lib', 'lib/generated']
  s.homepage    = 'https://ilovevideoeditor.com'
  s.license     = 'MIT'
  s.required_ruby_version = '>= 3.0'
  s.add_runtime_dependency 'typhoeus', '~> 1.0', '>= 1.0.1'
end
