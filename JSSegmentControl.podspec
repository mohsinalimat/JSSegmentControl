Pod::Spec.new do |s|

    s.name             = 'JSSegmentControl'
    s.version          = '1.0.0'
    s.summary          = '一个简便易用的自定义 Segment 框架。'
  
    s.description      = <<-DESC
    一个简便易用的自定义 Segment 框架，方便快捷的定制 Segment。
                         DESC
  
    s.homepage         = 'https://github.com/spirit-jsb/JSSegmentControl'
  
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
  
    s.author           = { 'spirit-jsb' => 'sibo_jian_29903549@163.com' }
  
    s.swift_version = '4.0'
  
    s.ios.deployment_target = '9.0'
  
    s.source           = { :git => 'https://github.com/spirit-jsb/JSSegmentControl.git', :tag => s.version.to_s }
    
    s.source_files = 'Sources/**/*.swift'
    
    s.requires_arc = true
    s.frameworks = 'UIKit', 'Foundation'
  
  end