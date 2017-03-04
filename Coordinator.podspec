Pod::Spec.new do |s|
  s.name         = 'Coordinator'
  s.version      = '3.0.2'
  s.summary      = 'Advanced implementation of (Application) Coordinator software design pattern in Swift 3. It implements a mechanism to allow implementation of custom messaging between any UIView, UIViewController and Coordinator, regardless of where in the hierarchy they are. It thus side-steps the need for delegates all over your code. It simplifies testing and allows creation of self-contained visual boxes that do one thing and don’t care where are they embedded or presented.'
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
