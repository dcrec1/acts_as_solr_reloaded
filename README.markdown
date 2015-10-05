[![Build status](https://secure.travis-ci.org/coletivoEITA/acts_as_solr_reloaded.png?branch=master)](http://travis-ci.org/coletivoEITA/acts_as_solr_reloaded)

Description
======
This plugin adds full text search capabilities and many other nifty features from Apache's [Solr](http://lucene.apache.org/solr/) to any Rails model.
It was based on the first draft by Erik Hatcher.

This plugin is intended for use in old versions of Rails. For newer versions, I strongly advice using Sunspot!
Nevertheless, this plugin is used for Noosfero project in production. Any problem please open an issue.

It should support Rails 2.1 (and greater 2.x) and is developed latest Solr versions, so don't expect it to run on older Solr.

Installation
======

Install as a plugin

    script/plugin install git://github.com/brauliobo/acts_as_solr_reloaded.git

Download Solr

    rake solr:download

Requirements
------
* Java Runtime Environment(JRE) 6.0 (or newer) from Oracle or OpenJDK

Configuration
======
See config/solr.yml file.

For solr configuration the important files are solrconfig.xml and schema.xml.

Basic Usage
======
Just include the line below to any of your ActiveRecord models:

    acts_as_solr

Or if you want, you can specify only the fields that should be indexed:

    acts_as_solr :fields => [:name, :author]
    
Then to find instances of your model, just do:

    Model.search(query) #query is a string representing your query

Please see ActsAsSolr::ActsMethods for a complete info

Pagination
======
ActsAsSolr implements in SearchResults class an interface compatible with will_paginate and maybe others.

In your tests
======
To test code that uses `acts_as_solr` you must start a Solr server for the test environment.
You can add to the beginning of your test/test_helper.rb the code:

    ENV["RAILS_ENV"] = "test"
    abort unless system 'rake solr:start' 
    at_exit { system 'rake solr:stop' }

However, if you would like to mock out Solr calls so that a Solr server is not needed (and your tests will run much faster), just add this to your `test_helper.rb` or similar:

    class ActsAsSolr::Post
      def self.execute(request)
        true
      end
    end

Or to be more realistic and preserve performance, enable Solr when needed,
by calling `TestSolr.enable` and disable solr otherwise by calling
`TestSolr.disable` on `Test::Unit::TestCase`'s `setup`:

     class ActsAsSolr::Post
       class << self
         alias_method :execute_orig, :execute
       end
     end
     module ActsAsSolr::ParserMethods
       alias_method :parse_results_orig, :parse_results
     end
     
     class TestSolr
     
       def self.enable
         ActsAsSolr::Post.class_eval do
           def self.execute(*args)
             execute_orig *args
           end
         end
         ActsAsSolr::ParserMethods.module_eval do
           def parse_results(*args)
             parse_results_orig *args
           end
         end
     
         # clear index
         ActsAsSolr::Post.execute(Solr::Request::Delete.new(:query => '*:*'))
     
         @solr_disabled = false
       end
     
       def self.disable
         return if @solr_disabled
     
         ActsAsSolr::Post.class_eval do
           def self.execute(*args)
             true
           end
         end
         ActsAsSolr::ParserMethods.module_eval do
           def parse_results(*args)
             parse_results_orig nil, args[1]
           end
         end
     
         @solr_disabled = true
       end
     
     end
     
     # disable solr actions by default
     TestSolr.disable

Release Information
======
Released under the MIT license.
