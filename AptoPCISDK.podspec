#
# Be sure to run `pod lib lint AptoPCISDK.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "AptoPCISDK"
  s.version          = "1.0.2"
  s.summary          = "The Apto platform iOS PCI SDK."
  s.description      = <<-DESC
  Apto iOS PCI SDK. Use this SDK to show card PCI protected data in your app. Please contact us for more information.
  DESC
  s.homepage         = "https://github.com/AptoPayments/apto-pci-sdk-ios.git"
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.authors          = { "Pau Teruel" => "pau@aptopayments.com" }
  s.source           = { :git => "https://github.com/AptoPayments/apto-pci-sdk-ios.git", :tag => "1.0.2" }

  s.platform = :ios
  s.ios.deployment_target = '10.0'
  s.swift_version = '5.0'
  s.requires_arc = true

  s.module_name = 'AptoPCISDK'
  s.source_files = 'AptoPCISDK/Classes/**/*'
  s.resources = ["AptoPCISDK/Assets/**/*"]
end
