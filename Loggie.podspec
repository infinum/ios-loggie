Pod::Spec.new do |s|
  s.name             = 'Loggie'
  s.version          = '2.3.1'
  s.summary          = 'In-app network logging library.'
  s.homepage         = 'https://github.com/infinum/iOS-Loggie.git'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Filip Beć' => 'filip.bec@gmail.com' }
  s.source           = { :git => 'https://github.com/infinum/iOS-Loggie.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/FilipBec'
  s.swift_version    = '5.0'
  s.ios.deployment_target = '9.0'

  s.source_files = 'Loggie/Classes/**/*.{swift}'
  s.resource_bundles = {'LoggieResources' => ['Loggie/Classes/**/*.{storyboard,xib}']}
  s.resources = ['Loggie/Classes/**/*.{xib,storyboard}']

  s.frameworks = 'UIKit', 'Security'
end
