$: << File.join(File.dirname(__FILE__), '..', 'lib')
$: << File.join(File.dirname(__FILE__))

require 'rubygems'
require 'test/unit'
require 'activerecord'
require 'factory_girl'
gem 'thoughtbot-shoulda', ">= 2.0.0"
require 'shoulda'
require 'mocha'
require 'models'
