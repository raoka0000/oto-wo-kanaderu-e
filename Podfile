platform :ios, “7.0”
workspace '/Users/raoka0000/Desktop/ios/音を奏でる絵4/音を奏でる絵4.xcworkspace'

post_install do |installer|
  installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
          config.build_settings['SWIFT_VERSION'] = '2.3'
      end
   end
end