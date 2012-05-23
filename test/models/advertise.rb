# Table fields for 'advertises'
# - id

class Advertise < ActiveRecord::Base
  acts_as_solr :spatial => true
end
