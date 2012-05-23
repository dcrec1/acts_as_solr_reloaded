module ActsAsSolr
  class Post
    class << self
      def config
        return @config if @config
        @config = {}
        YAML::load_file("#{Rails.root}/config/solr.yml")[Rails.env].each{ |k,v| @config[k.to_sym] = v }
        @config
      end

      def options
        @options ||= credentials.merge config
      end

      def credentials
        @credentials ||= {:username => config[:username], :password => config[:password]}
      end

      def url(core)
        core.nil? ? config[:url] : "#{config[:url]}/#{core}"
      end

      def execute(request, core = nil)
        connection = Solr::Connection.new(url(core), options)
        connection.send request
      end
    end
  end
end
