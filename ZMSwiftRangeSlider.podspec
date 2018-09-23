Pod::Spec.new do |s|
  s.name             = 'ZMSwiftRangeSlider'
  s.version          = '0.1.7'
  s.summary          = 'A simple Range Slider library by Swift.'
  s.homepage         = 'https://github.com/nanjingboy/ZMSwiftRangeSlider'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Tom.Huang' => 'hzlhu.dargon@gmail.com' }
  s.source           = { :git => 'https://github.com/nanjingboy/ZMSwiftRangeSlider.git', :tag => s.version.to_s }
  s.ios.deployment_target = '8.0'
  s.requires_arc = true
  s.source_files = "Source/*.swift"
end
