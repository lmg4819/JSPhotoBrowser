#
# Be sure to run `pod lib lint JSPhotoBrowser.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
s.name             = 'JSPhotoBrowser'
s.version          = '0.1.0'
s.summary          = '图片浏览器'


s.description      = <<-DESC
图片浏览器，可以浏览本地图片和网络图片，还能剪裁图片
DESC

s.homepage         = 'https://github.com/lmg4819/JSPhotoBrowser'

s.license          = { :type => 'MIT', :file => 'LICENSE' }
s.author           = { 'lmg' => '893788253@qq.com' }
s.source           = { :git => 'https://github.com/lmg4819/JSPhotoBrowser.git', :tag => s.version.to_s }

s.ios.deployment_target = '8.0'

s.source_files = 'JSPhotoBrowser/Classes/JSPhotoBrowser/**/*.{h,m}'

s.resource_bundles = {
'JSPhotoBrowser' => ['JSPhotoBrowser/Assets/*']
}

# s.public_header_files = 'Pod/Classes/**/*.h'
# s.frameworks = 'UIKit', 'MapKit'
s.dependency 'SDWebImage', '>= 4.0.0'
end
