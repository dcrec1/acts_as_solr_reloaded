module ActsAsSolr #:nodoc:

  # TODO: Possibly looking into hooking it up with Solr::Response::Standard
  #
  # Class that returns the search results with four methods.
  #
  #   books = Book.find_by_solr 'ruby'
  #
  # the above will return a SearchResults class with 4 methods:
  #
  # docs|results|records: will return an array of records found
  #
  #   books.records.empty?
  #   => false
  #
  # total|num_found|total_hits: will return the total number of records found
  #
  #   books.total
  #   => 2
  #
  # facets: will return the facets when doing a faceted search
  #
  # max_score|highest_score: returns the highest score found
  #
  #   books.max_score
  #   => 1.3213213
  #
  #
  class SearchResults

    include Enumerable

    def initialize(solr_data={})
      @solr_data = solr_data
    end

    def each(&block)
      self.results.each &block
    end

    # Returns an array with the instances. This method
    # is also aliased as docs and records
    def results
      @solr_data[:docs]
    end

    # Returns the total records found. This method is
    # also aliased as num_found and total_hits
    def total
      @solr_data[:total]
    end

    # Returns the facets when doing a faceted search
    def facets
      @solr_data[:facets]
    end

    # Returns the highest score found. This method is
    # also aliased as highest_score
    def max_score
      @solr_data[:max_score]
    end

    def query_time
      @solr_data[:query_time]
    end

    # Returns the highlighted fields which one has asked for..
    def highlights
      @solr_data[:highlights]
    end
    
    # Returns a suggested query
    def suggest
      Hash[@solr_data[:spellcheck]['suggestions']]['collation']
    end

    # Returns the number of documents per page
    def per_page
      @solr_data[:rows].to_i
    end

    # Returns the number of pages found
    def total_pages
      per_page.zero? ? 0 : (total / per_page.to_f).ceil
    end

    # Returns the current page
    def current_page
      per_page.zero? ? 0 : (@solr_data[:start].to_i / per_page) + 1
    end

    def blank?
      total_entries == 0
    end

    def size
      total_entries
    end

    def offset
      (current_page - 1) * per_page
    end

    def previous_page
      if current_page > 1
        current_page - 1
      else
        false
      end
    end

    def next_page
      if current_page < total_pages
        current_page + 1
      else
        false
      end
    end

    def method_missing(symbol, *args, &block)
      self.results.send(symbol, *args, &block)
    rescue NoMethodError
      raise NoMethodError, "There is no method called #{symbol} at #{self.class.name} - #{self.inspect}"
    end

    alias docs results
    alias records results
    alias num_found total
    alias total_hits total
    alias total_entries total
    alias highest_score max_score
  end

end

