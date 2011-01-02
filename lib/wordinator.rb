$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))
  
require 'wordinator/rules'
require 'wordinator/tag'
require 'wordinator/extractor'  
  
VERSION = '0.1.2'