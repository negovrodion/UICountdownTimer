#
# Be sure to run `pod lib lint UICountdownTimer.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'UICountdownTimer'
  s.version          = '0.1.0'
  s.summary          = 'UI component for timer or stopwatch.'

  s.description      = <<-DESC
UI component for timer or stopwatch. Based on UIPickerView.
                       DESC

  s.homepage         = 'https://github.com/negovrodion/UICountdownTimer'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Rodion Negov' => 'negovrodion@gmail.com' }
  s.source           = { :git => 'https://github.com/negovrodion/UICountdownTimer.git', :tag => s.version.to_s }

  s.ios.deployment_target = '10.0'

  s.swift_version = '4.0'

  s.source_files = 'UICountdownTimer/**/*'

end
