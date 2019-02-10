# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'trakt' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for trakt
  pod 'CodableAlamofire'
  pod 'SwifterSwift'
  pod 'SwiftyUserDefaults'
  pod 'SVProgressHUD'
  pod 'AlamofireNetworkActivityLogger', '~> 2.0'

  # pod 'IQKeyboardManagerSwift', '~> 6.1.1'
  
end

post_install do |installer|
    puts 'Removing static analyzer support'
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['OTHER_CFLAGS'] = "$(inherited) -Qunused-arguments -Xanalyzer -analyzer-disable-all-checks"
        end
    end
end
