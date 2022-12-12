Pod::Spec.new do |s|
    s.name             = 'MyPod-Podspec'
    s.version          = '0.0.20'
    s.summary          = 'By far the most SwiftUI view I have seen in my entire life. No joke.'
   
    s.description      = <<-DESC
  This SwiftUI view changes its color gradually makes your app look fantastic!
                         DESC
   
    s.homepage         = 'git@github.com:rohit11/SwiftUIExamples.git'
    s.license          = { :type => 'MIT', :file => 'MyPod-Podspec' }
    s.author           = { 'Rohit Nisal' => 'rohitnisal@gmail.com' }
    s.source           = { :git => 'git@github.com:rohit11/SwiftUIExamples.git', :tag => s.version.to_s }
   
    s.ios.deployment_target = '14.0'
    s.source_files = 'SwiftUIProject/*.{swift}'   
  end
