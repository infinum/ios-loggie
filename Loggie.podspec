Pod::Spec.new do |s|
  s.name             = 'Loggie'
  s.version          = '2.4.2'
  s.summary          = 'In-app network logging library.'
  s.homepage         = 'https://github.com/infinum/ios-loggie.git'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Filip Beć' => 'filip.bec@gmail.com' }
  s.source           = { :git => 'https://github.com/infinum/ios-loggie.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/FilipBec'
  s.swift_version    = '5.0'
  
  s.ios.deployment_target = '11.0'
  s.default_subspec = 'URLSession'

  s.subspec 'Core' do |sp| 
    sp.source_files = 'Loggie/Classes/Core/**/*.{swift}'
    sp.resource_bundles = {'LoggieResources' => ['Loggie/Classes/Core/**/*.{xib,storyboard}']}
    sp.resources = ['Loggie/Classes/Core/**/*.{xib,storyboard}']
    sp.frameworks = 'UIKit', 'Security'
    sp.ios.deployment_target = '11.0'
  end

  s.subspec 'Alamofire' do |sp| 
    sp.source_files = 'Loggie/Classes/Alamofire/**/*.{swift}'
    sp.dependency 'Loggie/Core'
    sp.dependency 'Alamofire', '~> 5.2'
    sp.ios.deployment_target = '11.0'
  end

  s.subspec 'URLSession' do |sp| 
    sp.source_files = 'Loggie/Classes/URLSession/**/*.{swift}'
    sp.dependency 'Loggie/Core'
    sp.ios.deployment_target = '11.0'
  end
  
end
