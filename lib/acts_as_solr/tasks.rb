dir = File.dirname(__FILE__)
require 'rubygems'
require 'rake'
require 'net/http'
require 'active_record'
require File.expand_path("#{dir}/solr_fixtures")

load File.expand_path("#{dir}/tasks/database.rake")
load File.expand_path("#{dir}/tasks/solr.rake")
load File.expand_path("#{dir}/tasks/test.rake")
