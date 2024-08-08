#
# Be sure to run `pod lib lint Heartland-iOS-SDK.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
    s.name             = "Heartland-iOS-SDK"
    s.version          = "2.0.25"
    s.summary          = "Secure Tokenized Payments by Heartland Payment Systems."
  
  # This description is used to generate tags and improve search results.
  #   * Think: What does it do? Why did you write it? What is the focus?
  #   * Try to keep it short, snappy and to the point.
  #   * Write the description between the DESC delimiters below.
  #   * Finally, don't worry about the indent, CocoaPods strips it!  
    s.description      = <<-DESC
    Secure Tokenized Payments for iOS by Heartland Payment Systems.
                         DESC
  
    s.homepage         = "https://github.com/hps/heartland-ios"
    s.license          = 'EULA'
    s.author           = { "Heartland Developer Portal" => "EntApp_DevPortal@e-hps.com" }
    s.source           = { :git => "https://github.com/hps/heartland-ios.git", :tag => s.version.to_s }
   
  
    s.platform     = :ios, '11.0'
    s.requires_arc = true
  
    s.source_files = ['Heartland-iOS-SDK/Classes/**/*', 'Heartland-iOS-SDK/ThirdParty/**/*']
    s.resource_bundles = {
      'Heartland-iOS-SDK' => ['Heartland-iOS-SDK/Assets/*.png', 'Heartland-iOS-SDK/Assets/*.xib']
    }
  
    s.frameworks = 'UIKit'
    s.vendored_frameworks = 'Heartland-iOS-SDK/Libraries/GlobalMobileSDK.xcframework', 'Heartland-iOS-SDK/Libraries/GlobalPaymentsApi.xcframework', 'Heartland-iOS-SDK/Libraries/BBPOS.xcframework'
    s.swift_version = '5.0'
    s.pod_target_xcconfig = { 
	'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' 
    }
    s.user_target_xcconfig = { 
	'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64'
    }
 
end
