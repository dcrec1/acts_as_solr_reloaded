require File.expand_path("#{File.dirname(__FILE__)}/test_helper")

class ActsMethodsTest < Test::Unit::TestCase
  class Model
    attr_accessor :birthdate

    def initialize(birthdate)
      @birthdate = birthdate
    end

    def self.configuration
      @configuration ||= {:solr_fields => {}}
    end

    def self.columns_hash=(columns_hash)
      @columns_hash = columns_hash
    end

    def self.columns_hash
      @columns_hash
    end

    def [](key)
      @birthday
    end

    self.extend ActsAsSolr::ActsMethods
  end

  class Abstract
    def self.acts_as_taggable_on(what)
      @_taggable = what.eql?(:tags)
    end

    def self.taggable?
      @_taggable
    end
    extend ActsAsSolr::ActsMethods
  end

  class Taggable < Abstract
    begin
      acts_as_solr :taggable => true
    rescue
    end
  end

  class NotTaggable < Abstract
  end
  
  class Mapper
    include MongoMapper::Document
    include ActsAsSolr::MongoMapper
    key :value1, String
    acts_as_solr
  end

  should "define the model as taggable if taggable is true" do
    assert Taggable.taggable?
  end

  should "not define the model as taggable if taggable is not true" do
    assert !NotTaggable.taggable?
  end
  
  should "define the type of a MongoMapper document id as text" do
    assert_equal :text, Mapper.configuration[:solr_fields][:_id][:type]
  end
  
  should "recognize the type String of a MongoMapper key as text" do
    assert_equal :text, Mapper.configuration[:solr_fields][:value1][:type]
  end

  context "when getting field values" do
    setup do
      Model.columns_hash = {"birthdate" => stub("column", :type => :date)}
      Model.send(:get_field_value, :birthdate)
    end

    should "define an accessor methods for a solr converted value" do
      assert Model.instance_methods.include?("birthdate_for_solr")
    end

    context "for date types" do
      setup do
        @model = Model.new(Date.today)
      end

      should "return nil when field is nil" do
        @model.birthdate = nil
        assert_nil @model.birthdate_for_solr
      end

      should "return the formatted date" do
        assert_equal Date.today.strftime("%Y-%m-%dT%H:%M:%SZ"), @model.birthdate_for_solr
      end
    end

    context "for timestamp types" do
      setup do
        @now = Time.now
        @model = Model.new(@now)
      end

      should "return a formatted timestamp string for timestamps" do
        assert_equal @now.utc.strftime("%Y-%m-%dT%H:%M:%SZ"), @model.birthdate_for_solr
      end
    end
  end
end
