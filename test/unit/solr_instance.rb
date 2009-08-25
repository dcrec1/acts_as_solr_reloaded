class SolrInstance
  include ActsAsSolr::InstanceMethods
  attr_accessor :configuration, :solr_configuration, :name

  class << self
    include ActsAsSolr::ActsMethods
    include ActsAsSolr::ClassMethods
  end

  def initialize(name = "Chunky bacon!")
    @name = name
  end
  
  def self.primary_key
    "id"
  end
  
  def logger
    @logger ||= Logger.new(StringIO.new)
  end
  
  def record_id(obj)
    10
  end
  
  def boost_rate
    10.0
  end
  
  def irate
    8.0
  end

  def name_for_solr
    name
  end
  
  def id_for_solr
    "bogus"
  end
  
  def type_for_solr
    "humbug"
  end
  
  def get_solr_field_type(args)
    "s"
  end
end

class Tagging
  attr_reader :tag
  
  def initialize(name)
    @tag = Tag.new name
  end
end

class Tag
  attr_reader :name

  def initialize(name)
    @name = name
  end
end

class Local
  attr_reader :longitude, :latitude

  def initialize(long, lati)
    @longitude = long
    @latitude = lati
  end
end
