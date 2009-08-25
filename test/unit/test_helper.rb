dir = File.dirname(__FILE__)
$:.unshift(File.join(File.expand_path(dir), "..", "..", "lib"))

require 'rubygems'
require 'test/unit'
require 'acts_as_solr'
require 'activesupport'
require 'mocha'
require 'active_support'
require 'logger'
require File.expand_path("#{dir}/solr_instance")
require File.expand_path("#{dir}/parser_instance")
require 'erb'
require 'ostruct'

if RUBY_VERSION =~ /^1\.9/
  puts "\nRunning the unit test suite doesn't as of yet work with Ruby 1.9, because Mocha hasn't yet been updated to use minitest."
  puts
  exit 1
end

require 'mocha'
gem 'thoughtbot-shoulda'
require 'shoulda'
