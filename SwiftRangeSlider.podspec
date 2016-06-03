Pod::Spec.new do |s|
  s.name             = 'SwiftRangeSlider'
  s.version          = '0.1.0'
  s.summary          = 'A simple Range Slider library by Swift.'
  s.description      = 'A simple Range Slider library by Swift.'
  s.homepage         = 'https://github.com/nanjingboy/SwiftRangeSlider'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Tom.Huang' => 'hzlhu.dargon@gmail.com' }
  s.source           = { :git => 'https://github.com/nanjingboy/SwiftRangeSlider.git', :tag => s.version.to_s }
  s.ios.deployment_target = '8.0'
  s.requires_arc = true
  s.source_files = "Source/*.swift"
end
