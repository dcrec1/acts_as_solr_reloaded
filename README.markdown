Description
======
This plugin adds full text search capabilities and many other nifty features from Apache's [Solr](http://lucene.apache.org/solr/) to any Rails model.
It was based on the first draft by Erik Hatcher.

Installation
======

    script/plugin install git://github.com/mattmatt/acts_as_solr.git

Requirements
------
* Java Runtime Environment(JRE) 1.5 aka 5.0 [http://www.java.com/en/download/index.jsp](http://www.java.com/en/download/index.jsp)
* If you have libxml-ruby installed, make sure it's at least version 0.7

Configuration
======
If you are using acts_as_solr as a Rails plugin, everything is configured to work out of the box. You can use `rake solr:start` and `rake solr:stop`
to start and stop the Solr web server (an embedded Jetty). If the default JVM options aren't suitable for
your environment, you can configure them in solr.yml with the option `jvm_options`. There is a default
set for the production environment to have some more memory available for the JVM than the defaults, but
feel free to change them to your liking.

If you are using acts_as_solr as a gem, create a file named lib/tasks/acts_as_solr.rake:
<pre><code>
require "acts_as_solr/tasks"
</code></pre>

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