$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))
  
require 'phrasie/rules'
require 'phrasie/tag'
require 'phrasie/extractor'

module Phrasie
  VERSION = '0.1.5'
end