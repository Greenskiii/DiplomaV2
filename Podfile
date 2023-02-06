# Uncomment the next line to define a global platform for your project




target 'Diploma_v2' do
platform :ios, '14.0'

  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!


post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '14.0'
    end
  end
end


inhibit_all_warnings!

  # Pods for Diploma_v2

pod 'FirebaseAuth'
pod 'FirebaseFirestore'
pod 'FirebaseCrashlytics'
pod 'FirebaseDatabase'
pod 'GoogleSignIn'
pod 'GoogleSignInSwiftSupport'
pod 'FirebaseFirestoreSwift'

end
