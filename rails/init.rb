require 'acts_as_solr'
require 'acts_as_solr/acts_as_dynamic_attributes'
require 'acts_as_solr/acts_as_local'

ActiveRecord::Base.send :include, ActiveRecord::Acts::DynamicAttributesOn
ActiveRecord::Base.send :include, ActiveRecord::Acts::LocalOn