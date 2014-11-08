Pod::Spec.new do |s|

  s.name         = "PhotoFilterProcessor"
  s.version      = "0.0.1"
  s.summary      = "easy making your original photo filter"
  s.description  = <<-DESC
                   DESC

  s.homepage     = "https://github.com/goccy/PhotoFilterProcessor"
  s.license      = { :type => 'MIT', :file => 'LICENSE.txt' }
  s.author       = { "Masaaki Goshima" => "goccy54@gmail.com" }
  s.platform     = :ios, '7.0'
  s.source       = { :git => "git@github.com:goccy/PhotoFilterProcessor.git", :tag => "0.0.1" }
  s.source_files = 'client/Library/*.{h,m}'
  s.requires_arc = true
  s.dependency 'Cadenza', :git => 'https://github.com/goccy/Cadenza.git'

end
