require 'rubygems'
require 'rake'
dir = File.dirname(__FILE__)
$:.unshift("#{dir}/lib")
RAILS_ROOT = dir
require "acts_as_solr/tasks"
