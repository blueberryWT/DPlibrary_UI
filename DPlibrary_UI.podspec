Pod::Spec.new do |s|
  s.name         = "DPlibrary_UI"
  s.version      = "1.0"
  s.summary      = "多朋自己封装的控件库，基本都使用了Bee"

  s.homepage     = "https://github.com/blueberryWT/DPlibrary_Bee"
  s.license      = 'MIT'

  s.author       = { "yutongfei","doujingxuan"}

  s.source       = { :git => 'git@github.com:blueberryWT/DPlibrary_Bee.git'}

  s.source_files = 'DPlibrary_Bee/DPlibBee/**/*.{h,m,mm}'


  s.resources = 'DPlibrary_Bee/BeeRes/*.{png,jpg}'
  s.platform     = :ios

  s.requires_arc = false
  s.framework = ['CoreGraphics','Foundation','QuartzCore','Security','UIKit']
  s.prefix_header_file = 'DPlibrary_Bee/DPlibrary_Bee-Prefix.pch'

  s.dependency 'JSONKit'
  s.dependency 'ASIHTTPRequest'
  s.dependency 'Reachability'
  s.dependency 'FMDB'
  s.dependency 'MBAlertView'
  s.dependency 'RegexKitLite'
  #...
end
