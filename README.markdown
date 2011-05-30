Description
======
This plugin adds full text search capabilities and many other nifty features from Apache's [Solr](http://lucene.apache.org/solr/) to any Rails model.
It was based on the first draft by Erik Hatcher.

This plugin is intended for use in old versions of Rails. For newer versions, I strongly advice using Sunspot!
Nevertheless, this plugin is used for Noosfero project in production. Any problem please open an issue.

Installation
======

Install as a plugin

    script/plugin install git://github.com/brauliobo/acts_as_solr_reloaded.git

Download Solr 3.1

    rake solr:download

Requirements
------
* Java Runtime Environment(JRE) 1.6 aka 6.0 or newer [http://www.java.com/en/download/index.jsp](http://www.java.com/en/download/index.jsp) (use default-jre for Debian like distribution)
* (Recommended) If you have libxml-ruby installed, make sure it's at least version 0.7

Configuration
======
See config/solr.yml file.

Basic Usage
======
<pre><code>
# Just include the line below to any of your ActiveRecord models:
  acts_as_solr

# Or if you want, you can specify only the fields that should be indexed:
  acts_as_solr :fields => [:name, :author]

# Then to find instances of your model, just do:
  Model.search(query) #query is a string representing your query

# Please see ActsAsSolr::ActsMethods for a complete info

</code></pre>


`acts_as_solr` in your tests
======
To test code that uses `acts_as_solr` you must start a Solr server for the test environment. You can do that with `rake solr:start RAILS_ENV=test`

However, if you would like to mock out Solr calls so that a Solr server is not needed (and your tests will run much faster), just add this to your `test_helper.rb` or similar:

<pre><code>
class ActsAsSolr::Post
  def self.execute(request)
    true
  end
end
</pre></code>

([via](http://www.subelsky.com/2007/10/actsassolr-capistranhttpwwwbloggercomim.html#c1646308013209805416))

Release Information
======
Released under the MIT license.
