require 'fileutils'

src = File.join(File.dirname(__FILE__), 'config', 'solr.yml')
target = File.join(File.dirname(__FILE__), '..', '..', '..', file)
FileUtils.cp src, target