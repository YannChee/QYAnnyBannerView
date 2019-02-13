Pod::Spec.new do |s|
  s.name         = "QYAnnyBannerView"
  s.version      = "0.1.0"
  s.summary      = "轻量级的bannerView,通过自定义cell支持任意Banner"

  s.description  = <<-DESC
                    这个是第一版,以后会继续完善更多功能
                   DESC

  s.homepage     = "https://github.com/YannChee/QYAnnyBannerView"

  s.license      = "MIT"

  s.author             = { "YannChee" => "email@address.com" }
  s.platform     = :ios, "8.0"


  s.source       = { :git => "https://github.com/YannChee/QYAnnyBannerView.git", :tag => s.version.to_s  }


  s.source_files  =  "QYAnnyBannerView/**/*"


  # s.public_header_files = "Classes/**/*.h"


  # ――― Project Linking ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Link your library with frameworks, or libraries. Libraries do not include
  #  the lib prefix of their name.
  #

  # s.framework  = "SomeFramework"
  # s.frameworks = "SomeFramework", "AnotherFramework"

  # s.library   = "iconv"
  # s.libraries = "iconv", "xml2"

  s.requires_arc = true

  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  # s.dependency "JSONKit", "~> 1.4"

end
