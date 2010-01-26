class Document
  include MongoMapper::Document
  include ActsAsSolr::MongoMapper
  key :name, String
  acts_as_solr
end