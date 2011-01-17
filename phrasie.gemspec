Gem::Specification.new do |s|
  s.name        = "phrasie"
  s.version     = '0.1.4'
  s.authors     = ["Ashley Williams"]
  s.email       = ["hi@ashleyw.co.uk"]
  s.summary     = "Determines important terms within a given piece of content."
  s.homepage         = "https://github.com/ashleyw/Phrasie"
  s.description = "Determines important terms within a given piece of content. It
  uses linguistic tools such as Parts-Of-Speech (POS) and some simple
  statistical analysis to determine the terms and their strength."
 
  s.required_rubygems_version = ">= 1.3.6"
  s.rubyforge_project         = "phrasie"
  
  s.files        = File.read("Manifest.txt").split("\n")
  s.require_path = 'lib'
end