require 'active_record'
require 'rexml/document'
require 'net/http'
require 'yaml'
require 'time'
require 'erb'
require 'rexml/xpath'

require File.dirname(__FILE__) + '/solr'
require File.dirname(__FILE__) + '/acts_as_solr/acts_methods'
require File.dirname(__FILE__) + '/acts_as_solr/common_methods'
require File.dirname(__FILE__) + '/acts_as_solr/parser_methods'
require File.dirname(__FILE__) + '/acts_as_solr/class_methods'
require File.dirname(__FILE__) + '/acts_as_solr/dynamic_attribute'
require File.dirname(__FILE__) + '/acts_as_solr/local'
require File.dirname(__FILE__) + '/acts_as_solr/instance_methods'
require File.dirname(__FILE__) + '/acts_as_solr/common_methods'
require File.dirname(__FILE__) + '/acts_as_solr/deprecation'
require File.dirname(__FILE__) + '/acts_as_solr/search_results'
require File.dirname(__FILE__) + '/acts_as_solr/lazy_document'
require File.dirname(__FILE__) + '/acts_as_solr/mongo_mapper'

module ActsAsSolr
  class Post
    class << self
      def config
        @config ||= YAML::load_file("#{Rails.root}/config/solr.yml")[Rails.env]
      end

      def credentials
        @credentials ||= {:username => config['username'], :password => config['password']}
      end

      def url(core)
        core.nil? ? config['url'] : "#{config['url']}/#{core}"
      end
    
      def execute(request, core = nil)
        connection = Solr::Connection.new(url(core), credentials)
        connection.send request
      end
    end
  end
end

# reopen ActiveRecord and include the acts_as_solr method
ActiveRecord::Base.extend ActsAsSolr::ActsMethods
