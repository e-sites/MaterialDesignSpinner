Pod::Spec.new do |s|
  s.name           = "MaterialDesignSpinner"
  s.platform       = :ios
  s.version        = "1.0.2"
  s.ios.deployment_target = "10.0"
  s.summary        = "An iOS activity spinner modeled after Google's Material Design Spinner"
  s.author         = { "Bas van Kuijck" => "bas@e-sites.nl" }
  s.license        = { :type => "MIT", :file => "LICENSE" }
  s.homepage       = "https://github.com/e-sites/#{s.name}"
  s.source         = { :git => "https://github.com/e-sites/#{s.name}.git", :tag => "v#{s.version.to_s}" }
  s.source_files   = 'Sources/**/*.{swift,h}'
  s.requires_arc   = true
  s.frameworks    = 'Foundation', 'UIKit'
  s.swift_versions = [ '5.1' ]
end
