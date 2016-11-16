source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '9.0'
use_frameworks!

target 'Stagram' do
    pod 'Alamofire', '4.0.0'
    pod 'AlamofireImage', '3.1.0'
    pod 'SwiftyJSON', '3.1.1'
    pod 'OAuthSwift', '1.1.0'
    pod 'HanekeSwift', :git => 'git@github.com:Haneke/HanekeSwift.git', :branch => 'feature/swift-3'
    pod 'SloppySwiper', '0.5'
    pod 'Fabric'
    pod 'Crashlytics'
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.0'
        end
    end
end

