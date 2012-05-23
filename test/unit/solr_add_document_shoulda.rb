require File.expand_path("#{File.dirname(__FILE__)}/../test_helper")

# This tests a solr-ruby modification

class SolrAddDocumentTest < Test::Unit::TestCase

  should "return correct handler" do
    assert_equal Solr::Request::AddDocument.new.handler, 'update/json'
  end

  should "have xml as response format" do
    assert_equal Solr::Request::AddDocument.new.response_format, :xml
  end

end
