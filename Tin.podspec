Pod::Spec.new do |s|
  s.name     = 'Tin'
  s.version  = '0.0.1'
  s.license  = 'MIT'
  s.summary  = 'Tin makes the internet easier in Cocoa.'
  s.homepage = 'https://github.com/pjaspers/Tin'
  s.author   = { 'pjaspers' => 'piet@jaspe.rs' }

  s.source   = { :git => 'https://github.com/pjaspers/Tin.git' }

  s.description = 'An optional longer description of Tin.'

  s.source_files = 'Classes', 'Classes/**/*.{h,m}', "Tin", "/"

  s.dependency 'JSONKit'
  s.dependency "AFNetworking"
end
