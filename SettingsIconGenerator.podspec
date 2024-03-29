Pod::Spec.new do |s|

  s.name = 'SettingsIconGenerator'
  s.version = '1.0.2'
  s.summary = 'Generator of settings icon by SF Symbols.'
  s.homepage = 'https://github.com/sparrowcode/SettingsIconGenerator'
  s.source = { :git => 'https://github.com/sparrowcode/SettingsIconGenerator.git', :tag => s.version }
  s.license = { :type => 'MIT', :file => "LICENSE" }
  s.author = { 'Ivan Vorobei' => 'hello@ivanvorobei.io' }
  
  s.swift_version = '5.1'
  s.ios.deployment_target = '13.0'
  s.tvos.deployment_target = '13.0'

  s.source_files  = 'Sources/SettingsIconGenerator/**/*.swift'

end
