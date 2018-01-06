#
# Be sure to run `pod lib lint SlidingPageTabViewController.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SlidingPageTabViewController'
  s.version          = '0.1.0'
  s.summary          = 'Horizontally slidable paging viewController with tab menu'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  - Horizontally scrolling a number of viewControllers.
  - Selectable a viewController as touch on tapBar menu.
  - Underline of menu will automatically move when user scroll viewControllers.
                       DESC

  s.homepage         = 'https://github.com/elliekwon/SlidingPageTabViewController'
  # s.screenshots      = 'https://github.com/elliekwon/SlidingPageTabViewController/blob/master/Demo/SlidingPageTabViewControllerDemo.gif'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'elliebkwon@gmail.com' => 'elliebkwon@gmail.com' }
  s.source           = { :git => 'https://github.com/elliekwon/SlidingPageTabViewController.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'Demo/SlidingPageTabViewController/**/*'
  
  # s.resource_bundles = {
  #   'SlidingPageTabViewController' => ['SlidingPageTabViewController/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
