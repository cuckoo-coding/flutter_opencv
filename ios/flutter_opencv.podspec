Pod::Spec.new do |s|
  s.name             = 'flutter_opencv'
  s.version          = '0.0.1'
  s.summary          = 'Flutter OpenCV'
  s.description      = <<-DESC
  A flutter package project which contains a collection of OpenCV modules.
                       DESC
  s.homepage         = 'https://github.com/cuckoo-coding/flutter_opencv'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'vasyl-sw14' => 'vasyl.shponarskyi@gmail.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.dependency 'OpenCV2', '4.3.0'
  s.platform = :ios, '9.0'
  s.static_framework = true

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
end
