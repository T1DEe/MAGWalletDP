platform :ios, '10.0'

use_frameworks!
inhibit_all_warnings!

workspace 'MAGWallet'

def swinject_pods
    pod 'Swinject', '2.5.0'
end


def helpers_pods
    pod 'R.swift', '5.0.0'
end


def main_pods
   pod 'CryptoSwift', '1.4.0'
end

def eth_pods
    pod 'web3swift.pod', :git => 'https://github.com/v-sharaev/web3swift'
    pod 'SwiftDate'
end

def shared_pods
    pod 'KeychainAccess', '3.2.0'
    pod 'BigNumber', :git => 'https://github.com/mkrd/Swift-Big-Integer.git'
end

def reachability_pods
  pod 'ReachabilitySwift'
end

def ui_helpers_pods
  pod 'SnapKit', '~> 4.0.0'
  pod 'lottie-ios', '3.1.2'
end

def firebase_pods
  pod 'Firebase/Messaging'
end

target 'MAGWallet' do
project 'MAGWallet.xcodeproj'
        
    swinject_pods
    helpers_pods

    shared_pods
    main_pods

    firebase_pods
    reachability_pods

    eth_pods
    
    ui_helpers_pods
    pod 'QRCodeReader.swift', '~> 8.0.3'
    
    target 'MAGWalletTests' do
    project 'MAGWallet.xcodeproj'
        inherit! :search_paths
    end

end

target 'NotificationServiceExtension' do
project 'MAGWallet.xcodeproj'
    helpers_pods
end

target 'ETHModule' do
project 'ETHModule/ETHModule.xcodeproj'
        
    swinject_pods
    helpers_pods
    shared_pods
    ui_helpers_pods
    eth_pods
    pod 'QRCodeReader.swift', '~> 8.0.3'
    main_pods

    target 'ETHModuleTests' do
    project 'ETHModule/ETHModule.xcodeproj'
    end
end

target 'BTCModule' do
project 'BTCModule/BTCModule.xcodeproj'
        
    swinject_pods
    helpers_pods
    shared_pods
    ui_helpers_pods
    main_pods
    pod 'QRCodeReader.swift', '~> 8.0.3'

    target 'BTCModuleTests' do
    project 'BTCModule/BTCModule.xcodeproj'
    end
end

target 'LTCModule' do
project 'LTCModule/LTCModule.xcodeproj'
        
    swinject_pods
    helpers_pods
    shared_pods
    ui_helpers_pods
    main_pods
    pod 'QRCodeReader.swift', '~> 8.0.3'

    target 'LTCModuleTests' do
    project 'LTCModule/LTCModule.xcodeproj'
    end
end

target 'SharedFilesModule' do
project 'SharedFilesModule/SharedFilesModule.xcodeproj'
        
    swinject_pods
    helpers_pods
    shared_pods
    
    target 'SharedFilesModuleTests' do
    project 'SharedFilesModule/SharedFilesModule.xcodeproj'
    end
end

target 'SharedUIModule' do
project 'SharedUIModule/SharedUIModule.xcodeproj'
    ui_helpers_pods
    helpers_pods
end

post_install do |installer|
  # This removes the warning about swift conversion, hopefuly forever!
  installer.pods_project.root_object.attributes['LastSwiftMigration'] = 9999
  installer.pods_project.root_object.attributes['LastSwiftUpdateCheck'] = 9999
  installer.pods_project.root_object.attributes['LastUpgradeCheck'] = 9999
  
  installer.pods_project.targets.each do |target|
    if ['QRCodeReader.swift'].include? target.name
      target.build_configurations.each do |config|
        config.build_settings['SWIFT_VERSION'] = '4.0'
      end
    end

    if target.name == 'web3swift.pod'
        target.build_configurations.each do |config|
            if config.name == 'Release'
                config.build_settings['SWIFT_OPTIMIZATION_LEVEL'] = '-Onone'
            else
                config.build_settings['SWIFT_OPTIMIZATION_LEVEL'] = '-Onone'
            end
        end
    end
  end
end
