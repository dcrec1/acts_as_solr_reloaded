ENV['RAILS_ENV']  = (ENV['RAILS_ENV'] || 'development').dup
require "uri"
require "fileutils"
require "yaml"
dir = File.dirname(__FILE__)
SOLR_PATH = File.expand_path("#{dir}/../solr") unless defined? SOLR_PATH

# RAILS_ROOT isn't defined yet, so figure it out.
unless defined? RAILS_ROOT
  RAILS_ROOT = File.expand_path("#{File.dirname(__FILE__)}/../test")
end
unless defined? SOLR_LOGS_PATH
  SOLR_LOGS_PATH = ENV["SOLR_LOGS_PATH"] || "#{RAILS_ROOT}/log"
end
unless defined? SOLR_PIDS_PATH
  SOLR_PIDS_PATH = ENV["SOLR_PIDS_PATH"] || "#{RAILS_ROOT}/tmp/pids"
end
unless defined? SOLR_DATA_PATH
  SOLR_DATA_PATH = ENV["SOLR_DATA_PATH"] || "#{RAILS_ROOT}/solr/#{ENV['RAILS_ENV']}"
end
unless defined? SOLR_CONFIG_PATH
  SOLR_CONFIG_PATH = ENV["SOLR_CONFIG_PATH"] || "#{SOLR_PATH}/solr"
end
unless defined? SOLR_PID_FILE
  SOLR_PID_FILE="#{SOLR_PIDS_PATH}/solr.#{ENV['RAILS_ENV']}.pid"
end

unless defined? SOLR_PORT
  config = YAML::load_file(RAILS_ROOT+'/config/solr.yml')
  raise("No solr environment defined for RAILS_ENV the #{ENV['RAILS_ENV'].inspect}") unless config[ENV['RAILS_ENV']]

  SOLR_HOST = ENV['HOST'] || URI.parse(config[ENV['RAILS_ENV']]['url']).host
  SOLR_PORT = ENV['PORT'] || URI.parse(config[ENV['RAILS_ENV']]['url']).port
end

SOLR_JVM_OPTIONS = config[ENV['RAILS_ENV']]['jvm_options'] unless defined? SOLR_JVM_OPTIONS

if ENV["ACTS_AS_SOLR_TEST"]
  require "activerecord"
  DB = (ENV['DB'] ? ENV['DB'] : 'sqlite') unless defined?(DB)
  MYSQL_USER = (ENV['MYSQL_USER'].nil? ? 'root' : ENV['MYSQL_USER']) unless defined? MYSQL_USER
  require File.join(File.dirname(File.expand_path(__FILE__)), '..', 'test', 'db', 'connections', DB, 'connection.rb')
end
