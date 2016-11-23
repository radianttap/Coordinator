Pod::Spec.new do |s|
  s.name         = 'Coordinator'
  s.version      = '1.0'
  s.summary      = 'Implementation of (Application) Coordinator software design pattern in Swift 3.'
  s.homepage     = 'https://github.com/radianttap/Coordinator'
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { 'Aleksandar Vacić' => 'radianttap.com' }
  s.social_media_url   			= "https://twitter.com/radiantav"
  s.ios.deployment_target 		= "8.2"
#  s.watchos.deployment_target 	= "2.0"
#  s.tvos.deployment_target 		= "9.0"
  s.source       = { :git => "https://github.com/radianttap/Coordinator.git" }
  s.source_files = 'Coordinator.swift'
  s.frameworks   = 'UIKit'
end
