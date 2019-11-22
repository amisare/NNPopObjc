Pod::Spec.new do |s|

  s.name          = "NNPopObjc"
  s.version       = "1.0.0"
  s.summary       = "Implement protocol extensions for protocol-oriented programming."

  s.description   = <<-DESC
                    Inspired by swift's protocol-oriented programming。
                    Based on runtime, the framework implements protocol extensions for protocol-oriented programming.
                    DESC

  s.homepage      = "https://github.com/amisare/NNPopObjc"
  s.license       = { :type => "MIT", :file => "LICENSE" }
  s.author        = { "Haijun Gu" => "243297288@qq.com" }
  s.social_media_url        = "https://www.jianshu.com/u/9df9f28ff266"

  s.source        = { :git => "https://github.com/amisare/NNPopObjc.git", :tag => s.version.to_s }
  
  s.requires_arc  = true
  s.libraries     = 'c++'

  s.osx.deployment_target       = '10.7'
  s.ios.deployment_target       = '6.0'
  s.tvos.deployment_target      = '9.0'
  s.watchos.deployment_target   = '2.0'

  s.source_files            = 'NNPopObjc/NNPopObjc/*.{h,m,mm}'
  
  s.subspec 'extobjc' do |ss|
    ss.source_files         = 'NNPopObjc/NNPopObjc/extobjc/*.{h,m}'
  end
  
  s.subspec 'Public' do |ss|
    ss.source_files         = 'NNPopObjc/NNPopObjc/Public/*.{h,m,mm}'
  end
  
  s.subspec 'Source' do |ss|
    ss.source_files         = 'NNPopObjc/NNPopObjc/Source/*.{h,m,mm}'
    ss.private_header_files = 'NNPopObjc/NNPopObjc/Source/*.{h}'
    ss.dependency           'NNPopObjc/extobjc'
    ss.dependency           'NNPopObjc/Public'
  end
  
end
  
