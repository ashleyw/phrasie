$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))
  
require 'term_extractor/rules'
require 'term_extractor/tag'
require 'term_extractor/extractor'  
  
VERSION = '0.1'