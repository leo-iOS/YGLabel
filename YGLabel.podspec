#
# Be sure to run `pod lib lint YGLabel.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'YGLabel'
  s.version          = '0.1.0'
  s.summary          = 'A lightweight Label for iOS, using CoreText'

  s.description      = <<-DESC
  A lightweight Label for iOS, using CoreText
                       DESC

  s.homepage         = 'https://github.com/199320701@qq.com/YGLabel'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { '199320701@qq.com' => '199320701@qq.com' }
  s.source           = { :git => 'https://github.com/199320701@qq.com/YGLabel.git', :tag => s.version.to_s }

  s.ios.deployment_target = '9.0'

  s.source_files = 'YGLabel/**/*'
  
end
