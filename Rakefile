require 'rubygems'
require 'bundler'
Bundler.require
require 'hoe'
require 'fileutils'
require './lib/phrasie'

Hoe.plugin :newgem

$hoe = Hoe.spec 'phrasie' do
  self.developer 'Ashley Williams', 'hi@ashleyw.co.uk'
  self.rubyforge_name = self.name # TODO this is default value
  self.urls = []
end

require 'newgem/tasks'
Dir['tasks/**/*.rake'].each { |t| load t }
