#
# Be sure to run `pod lib lint KMOnlineWeb.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'KMOnlineWeb'
  s.version          = '0.1.6'
  s.summary          = 'A short description of KMOnlineWeb.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/zhenlove/KMOnlineWeb'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'zhenlove' => '121910347@qq.com' }
  s.source           = { :git => 'https://github.com/zhenlove/KMOnlineWeb.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'
  s.xcconfig     = { 'VALID_ARCHS' => 'armv7 arm64 x86_64'}
  s.pod_target_xcconfig = {'DEFINES_MODULE' => 'YES','OTHER_LDFLAGS' => '"-ObjC"'}
  s.static_framework = true  #因为 KMAgoraRtc 是静态库，所以本库也需要设置为静态库
  s.ios.deployment_target = '9.0'
  s.swift_version = '5.0'
#  s.source_files = 'KMOnlineWeb/Classes/**/*{h,m,swift}'
  s.source_files = 'KMOnlineWeb/Classes/**/*{swift}'
  s.resource_bundles = {
    'KMOnlineWeb' => ['KMOnlineWeb/Assets/*']
  }
  s.dependency 'KMTIMSDK','~> 0.1.6'
  s.dependency 'KMNetwork','~> 0.1.4'
  s.dependency 'KMAgoraRtc','~> 1.0.7'
  s.dependency 'Kingfisher','~> 4.10.1'
end
