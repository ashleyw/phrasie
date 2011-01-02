require 'rubygems'
gem 'hoe', '>= 2.1.0'
require 'hoe'
require 'fileutils'
require './lib/wordinator'

Hoe.plugin :newgem

$hoe = Hoe.spec 'wordinator' do
  self.developer 'Ashley Williams', 'hi@ashleyw.co.uk'
  self.rubyforge_name = self.name # TODO this is default value
end

require 'newgem/tasks'
Dir['tasks/**/*.rake'].each { |t| load t }
