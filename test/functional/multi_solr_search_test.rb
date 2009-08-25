require File.join(File.dirname(__FILE__), '../test_helper')

class ActsAsSolrTest < Test::Unit::TestCase
  
  fixtures :books, :movies

  # Testing the multi_solr_search with the returning results being objects
  def test_multi_solr_search_return_objects
    records = Book.multi_solr_search "Napoleon OR Tom", :models => [Movie], :results_format => :objects
    assert_equal 2, records.total
    classes = records.docs.map {|d| d.class}
    assert classes.include?(Book)
    assert classes.include?(Movie)
  end
  
  # Testing the multi_solr_search with the returning results being ids
  def test_multi_solr_search_return_ids
    records = Book.multi_solr_search "Napoleon OR Tom", :models => [Movie], :results_format => :ids
    assert_equal 2, records.total
    assert records.docs.include?({"id" => "Movie:1"})
    assert records.docs.include?({"id" => "Book:1"})
  end
  
  # Testing the multi_solr_search with multiple models
  def test_multi_solr_search_multiple_models
    # TODO: Generalize me
    ActsAsSolr::Post.execute(Solr::Request::Delete.new(:query => 'type_s:Author AND NOT id:"Author:1" AND NOT id:"Author:2"'))
    ActsAsSolr::Post.execute(Solr::Request::Delete.new(:query => 'type_s:Book AND NOT id:"Book:1" AND NOT id:"Book:2"'))
    ActsAsSolr::Post.execute(Solr::Request::Commit.new)

    records = Book.multi_solr_search "Napoleon OR Tom OR Thriller", :models => [Movie, Category], :results_format => :ids
    assert_equal 3, records.total
    assert records.docs.include?({"id" => "Category:1"})
    assert records.docs.include?({"id" =>"Book:1"})
    assert records.docs.include?({"id" => "Movie:1"})
  end
  
  # Testing empty result set format
  def test_returns_no_matches
    records = Book.multi_solr_search "not found", :models => [Movie, Category]
    assert_equal [], records.docs
    assert_equal 0, records.total
  end
  
  def test_search_on_empty_string_does_not_return_nil
    records = Book.multi_solr_search('', :models => [Movie, Category])
    assert_not_nil records
    assert_equal [], records.docs
    assert_equal 0, records.total
  end
  
  def test_search_with_score_should_set_score
    records = Book.multi_solr_search "Napoleon OR Tom", :models => [Movie], :results_format => :objects, :scores => true
    assert records.docs.first.solr_score.is_a?(Float)
    assert records.docs.last.solr_score.is_a?(Float)
  end
end
