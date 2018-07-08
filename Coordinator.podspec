Pod::Spec.new do |s|
  s.name         = 'Coordinator'
  s.version      = '6.0'
  s.summary      = 'Advanced implementation of (Application) Coordinator software design pattern, in Swift 4.1.'
  s.description  = 'It implements a mechanism to allow custom messaging between any UIView, UIViewController and Coordinator, regardless of where in the hierarchy they are. Thus it side-steps the need for delegates all over your code. It simplifies testing and allows creation of self-contained visual boxes that do one thing and don’t care where are they embedded or presented.'
  s.homepage     = 'https://github.com/radianttap/Coordinator'
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { 'Aleksandar Vacić' => 'radianttap.com' }
  s.social_media_url   			= "https://twitter.com/radiantav"
  s.ios.deployment_target 		= "8.2"
  s.source       = { :git => "https://github.com/radianttap/Coordinator.git", :tag => s.version }
  s.source_files = '*.swift'
  s.frameworks   = 'UIKit'
  s.swift_version = '4.0'
end
