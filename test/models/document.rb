class Document
  include MongoMapper::Document
  extend ActsAsSolr::ActsMethods
  key :name, String
  acts_as_solr
end