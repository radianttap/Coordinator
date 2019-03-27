Pod::Spec.new do |s|
  s.name						= "Marshal"
  s.version						= "1.3.1"
  s.summary						= "Marshal is a simple, lightweight framework for safely extracting values from [String: AnyObject]"
  s.description					= <<-DESC
                   					In Swift, we all deal with JSON, plists, and various forms of [String: Any]. Marshal believes you don't need a Ph.D. in monads or magic mirrors to deal with these in an expressive and type safe way. Marshal will help you write declarative, performant, error handled code using the power of Protocol Oriented Programming™.
                   				  DESC
  s.homepage					= "https://github.com/utahiosmac/Marshal"
  s.license						= "MIT"
  s.author						= "Utah iOS & Mac"
  s.osx.deployment_target		= "10.9"
  s.ios.deployment_target		= "8.0"
  s.tvos.deployment_target		= "9.0"
  s.watchos.deployment_target	= "3.0"
  s.source						= { :git => "https://github.com/utahiosmac/Marshal.git",
									:tag => "#{s.version}" }
  s.source_files				= "Marshal/**/*.swift", "Sources/**/*.swift"
  s.module_name					= "Marshal"
  s.swift_versions				= ["4.2", "5.0"]
end
