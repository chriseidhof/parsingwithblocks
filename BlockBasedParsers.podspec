#
#  Be sure to run `pod spec lint BlockBasedParsers.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  These will help people to find your library, and whilst it
  #  can feel like a chore to fill in it's definitely to your advantage. The
  #  summary should be tweet-length, and the description more in depth.
  #

  s.name         = "BlockBasedParsers"
  s.version      = "0.0.1"
  s.summary      = "Parser combinators in Objective-C"

  s.description  = <<-DESC
                   A longer description of BlockBasedParsers in Markdown format.

                   * Think: Why did you write this? What is the focus? What does it do?
                   * CocoaPods will be using this to generate tags, and improve search results.
                   * Try to keep it short, snappy and to the point.
                   * Finally, don't worry about the indent, CocoaPods strips it!
                   DESC

  s.homepage     = "https://github.com/chriseidhof/parsingwithblocks"

  s.license      = "MIT (example)"
  
  s.author             = { "Chris Eidhof" => "chris@eidhof.nl" }
  s.social_media_url   = "http://twitter.com/chriseidhof"


  s.source       = { :git => "git@github.com:chriseidhof/parsingwithblocks.git", :tag => "0.0.1" }

  s.source_files  = "/Parsers/Parser.{h,m}"

  s.requires_arc = true


end
