# Table fields for 'advertises'
# - id

class Advertise < ActiveRecord::Base
  acts_as_solr :dynamic_attributes => true, :spatial => true
end
