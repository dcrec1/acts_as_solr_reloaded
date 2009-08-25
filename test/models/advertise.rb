# Table fields for 'advertises'
# - id

class Advertise < ActiveRecord::Base
  has_one :local
  has_many :dynamic_attributes
  acts_as_solr :dynamic_attributes => true, :spatial => true
end
