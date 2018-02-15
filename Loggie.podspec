Pod::Spec.new do |s|
  s.name             = 'Loggie'
  s.version          = '0.2.0'
  s.summary          = 'In-app network logging library.'
  s.homepage         = 'https://github.com/infinum/iOS-Loggie.git'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Filip Beć' => 'filip.bec@gmail.com' }
  s.source           = { :git => 'https://github.com/infinum/iOS-Loggie.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/FilipBec'

  s.ios.deployment_target = '8.0'

  s.source_files = 'Loggie/Classes/**/*.{swift}'
  s.resources = [
    'Loggie/Classes/**/*.{storyboard}',
    'Loggie/Classes/**/*.{xib}'
  ]

  s.frameworks = 'UIKit', 'Security'
end
