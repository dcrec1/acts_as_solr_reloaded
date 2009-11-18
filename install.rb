require 'fileutils'

src = File.join(File.dirname(__FILE__), 'config', 'solr.yml')
target = File.join(File.dirname(__FILE__), '..', '..', '..', 'config', 'solr.yml')
FileUtils.cp src, target