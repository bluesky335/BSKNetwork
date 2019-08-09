#
# Be sure to run `pod lib lint BSKNetwork.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'BSKNetwork'
  s.version          = '0.1.3'
  s.summary          = '一个Alamofire的封装'
  s.swift_version    = '4.2'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
对Alamofire的一个封装，更方便的添加和管理API接口
                       DESC

  s.homepage         = 'https://github.com/bluesky335/BSKNetwork'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'bluesky335' => 'chinabluesky335@gmail.com' }
  s.source           = { :git => 'https://github.com/bluesky335/BSKNetwork.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

  s.source_files = 'BSKNetwork/BSKNetwork/Classes/**/*'
  
  # s.resource_bundles = {
  #   'BSKNetwork' => ['BSKNetwork/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
   s.dependency 'Alamofire', '~> 4.8.2'
   s.dependency 'BSKConsole', '= 0.1.0'
end
