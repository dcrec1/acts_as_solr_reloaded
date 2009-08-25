require 'rubygems'
require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

Dir["#{File.dirname(__FILE__)}/lib/acts_as_solr/tasks/**/*.rake"].sort.each { |ext| load ext }

desc "Default Task"
task :default => [:test]

desc "Runs the unit tests"
task :test => "test:unit"

namespace :test do
  task :setup do
    RAILS_ROOT = File.expand_path("#{File.dirname(__FILE__)}/test") unless defined? RAILS_ROOT
    ENV['RAILS_ENV'] = "test"
    ENV["ACTS_AS_SOLR_TEST"] = "true"
    require File.expand_path("#{File.dirname(__FILE__)}/config/solr_environment")
    puts "Using " + DB
    %x(mysql -u#{MYSQL_USER} < #{File.dirname(__FILE__) + "/test/fixtures/db_definitions/mysql.sql"}) if DB == 'mysql'

    Rake::Task["test:migrate"].invoke
  end
  
  desc 'Measures test coverage using rcov'
  task :rcov => :setup do
    rm_f "coverage"
    rm_f "coverage.data"
    rcov = "rcov --rails --aggregate coverage.data --text-summary -Ilib"
    
    system("#{rcov} --html #{Dir.glob('test/**/*_shoulda.rb').join(' ')}")
    system("open coverage/index.html") if PLATFORM['darwin']
  end
  
  desc 'Runs the functional tests, testing integration with Solr'
  Rake::TestTask.new('functional' => :setup) do |t|
    t.pattern = "test/functional/*_test.rb"
    t.verbose = true
  end
  
  desc "Unit tests"
  Rake::TestTask.new(:unit) do |t|
    t.libs << 'test/unit'
    t.pattern = "test/unit/*_shoulda.rb"
    t.verbose = true
  end
end

Rake::RDocTask.new do |rd|
  rd.main = "README.rdoc"
  rd.rdoc_dir = "rdoc"
  rd.rdoc_files.exclude("lib/solr/**/*.rb", "lib/solr.rb")
  rd.rdoc_files.include("README.rdoc", "lib/**/*.rb")
end

begin
  require 'jeweler'
  Jeweler::Tasks.new do |s|
    s.name = "muck-solr"
    s.summary = "This gem adds full text search capabilities and many other nifty features from Apache�s Solr to any Rails model. I'm currently rearranging the test suite to include a real unit test suite, and adding a few features I need myself."
    s.email = "meyer@paperplanes.de"
    s.homepage = "http://github.com/mattmatt/acts_as_solr"
    s.description = "This gem adds full text search capabilities and many other nifty features from Apache�s Solr to any Rails model. I'm currently rearranging the test suite to include a real unit test suite, and adding a few features I need myself."
    s.authors = ["Mathias Meyer, Joel Duffin, Justin Ball"]
    s.rubyforge_project = 'muck-solr'
    s.files =  FileList["[A-Z]*", "{bin,generators,config,lib,solr}/**/*"] +
      FileList["test/**/*"].reject {|f| f.include?("test/log")}.reject {|f| f.include?("test/tmp")}
  end
rescue LoadError
  puts "Jeweler, or one of its dependencies, is not available. Install it with: sudo gem install technicalpickles-jeweler -s http://gems.github.com"
end

# rubyforge tasks
begin
  require 'rake/contrib/sshpublisher'
  namespace :rubyforge do

    desc "Release gem and RDoc documentation to RubyForge"
    task :release => ["rubyforge:release:gem", "rubyforge:release:docs"]

    namespace :release do
      desc "Publish RDoc to RubyForge."
      task :docs => [:rdoc] do
        config = YAML.load(
            File.read(File.expand_path('~/.rubyforge/user-config.yml'))
        )

        host = "#{config['username']}@rubyforge.org"
        remote_dir = "/var/www/gforge-projects/muck-solr/"
        local_dir = 'rdoc'

        Rake::SshDirPublisher.new(host, remote_dir, local_dir).upload
      end
    end
  end
rescue LoadError
  puts "Rake SshDirPublisher is unavailable or your rubyforge environment is not configured."
end
