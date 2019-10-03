Pod::Spec.new do |s|

  s.name          = "NNPopObjc"
  s.version       = "0.0.1"
  s.summary       = "Implement protocol extensions for protocol-oriented programming."

  s.description   = <<-DESC
                    Inspired by swift's protocol-oriented programming。
                    Based on runtime, the framework implements protocol extensions for protocol-oriented programming.
                    DESC

  s.homepage      = "https://github.com/amisare/NNPopObjc"
  s.license       = { :type => "MIT", :file => "LICENSE" }
  s.author        = { "Haijun Gu" => "243297288@qq.com" }
  s.social_media_url        = "http://www.jianshu.com/users/9df9f28ff266/latest_articles"

  s.source        = { :git => "https://github.com/amisare/NNPopObjc.git", :tag => s.version }
  
  s.user_target_xcconfig = { 'OTHER_LDFLAGS' => '-ObjC' }
  
  s.ios.deployment_target   = '7.0'
  s.requires_arc  = true

  s.source_files        = 'NNPopObjc/NNPopObjc/*.{h,m}'
  s.public_header_files = 'NNPopObjc/NNPopObjc/NNPopObjc.h'
end
  
