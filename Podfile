platform :ios, '8.0'

use_frameworks!

workspace 'NNPopObjc.xcworkspace'

def all_pods
    pod 'NNPopObjc', :path => 'NNPopObjc.podspec'
end

target :NNPopObjcDemo do
    project './NNPopObjcDemo/NNPopObjcDemo'
    all_pods
end
