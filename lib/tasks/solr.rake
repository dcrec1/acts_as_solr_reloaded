namespace :solr do

  SOLR_VERSION = '3.5.0'
  APACHE_MIRROR = "http://ftp.unicamp.br/pub/apache"
  SOLR_FILENAME = "apache-solr-#{SOLR_VERSION}.tgz" 
  SOLR_DIR = "apache-solr-#{SOLR_VERSION}" 
  SOLR_URL = "#{APACHE_MIRROR}/lucene/solr/#{SOLR_VERSION}/#{SOLR_FILENAME}" 

  desc "Download and install Solr+Jetty #{SOLR_VERSION}."
  task :download do
    if File.exists?(Rails.root + 'vendor/plugins/acts_as_solr_reloaded/solr/start.jar')
      puts 'Solr already downloaded.'
    else
      Dir.chdir '/tmp' do
        sh "wget -c #{SOLR_URL}"
        if !File.directory?("/tmp/#{SOLR_DIR}")
          sh "tar xzf apache-solr-#{SOLR_VERSION}.tgz"
        end
        cd "apache-solr-#{SOLR_VERSION}/example"
        cp_r ['../LICENSE.txt', '../NOTICE.txt', 'README.txt', 'etc', 'lib', 'start.jar', 'webapps', 'work'], Rails.root + 'vendor/plugins/acts_as_solr_reloaded/solr', :verbose => true
        cd 'solr'
        cp_r ['README.txt', 'bin', 'solr.xml'], Rails.root + 'vendor/plugins/acts_as_solr_reloaded/solr/solr', :verbose => true
      end
    end
  end

  desc 'Remove Solr instalation from the tree.'
  task :remove do
    solr_root = Rails.root + 'vendor/plugins/acts_as_solr_reloaded/solr/'
    rm_r ['README.txt', 'bin', 'solr.xml'].map{ |i| File.join(solr_root, 'solr', i) }, :verbose => true, :force => true
    rm_r ['LICENSE.txt', 'NOTICE.txt', 'README.txt', 'etc', 'lib', 'start.jar', 'webapps', 'work'].map{ |i| File.join(solr_root, i) }, :verbose => true, :force => true
  end

  desc 'Update to the newest supported version of solr'
  task :update => [:remove, :download] do
  end

  desc 'Starts Solr. Options accepted: RAILS_ENV=your_env, PORT=XX. Defaults to development if none.'
  task :start => [:download, :environment] do
    require File.expand_path("#{File.dirname(__FILE__)}/../../config/solr_environment")
    FileUtils.mkdir_p(SOLR_LOGS_PATH)
    FileUtils.mkdir_p(SOLR_DATA_PATH)
    FileUtils.mkdir_p(SOLR_PIDS_PATH)

    # test if there is a solr already running
    begin
      n = Net::HTTP.new('127.0.0.1', SOLR_PORT)
      n.request_head('/').value 

    rescue Net::HTTPServerException #responding
      puts "Port #{SOLR_PORT} in use" and return

    rescue Errno::ECONNREFUSED, Errno::EBADF, NoMethodError #not responding
      # there's an issue with Net::HTTP.request where @socket is nil and raises a NoMethodError
      # http://redmine.ruby-lang.org/issues/show/2708
      Dir.chdir(SOLR_PATH) do
        cmd = "java #{SOLR_JVM_OPTIONS} -Djetty.logs=\"#{SOLR_LOGS_PATH}\" -Dsolr.solr.home=\"#{SOLR_CONFIG_PATH}\" -Dsolr.data.dir=\"#{SOLR_DATA_PATH}\" -Djetty.host=\"#{SOLR_HOST}\" -Djetty.port=#{SOLR_PORT} -jar start.jar"
        puts "Executing: " + cmd
        windows = RUBY_PLATFORM =~ /(win|w)32$/
        if windows
          exec cmd
        else
          pid = fork do
            Process.setpgrp
            STDERR.close
            exec cmd 
          end
        end
        File.open(SOLR_PID_FILE, "w"){ |f| f << pid} unless windows
        puts "#{ENV['RAILS_ENV']} Solr started successfully on #{SOLR_HOST}:#{SOLR_PORT}, pid: #{pid}."
      end
    end
  end
  
  desc 'Stops Solr. Specify the environment by using: RAILS_ENV=your_env. Defaults to development if none.'
  task :stop => :environment do
    require File.expand_path("#{File.dirname(__FILE__)}/../../config/solr_environment")
    if File.exists?(SOLR_PID_FILE)
      killed = false
      File.open(SOLR_PID_FILE, "r") do |f| 
        pid = f.readline
        begin
          Process.kill('TERM', -pid.to_i)
          sleep 3
          killed = true
        rescue
          puts "Solr could not be found at pid #{pid.to_i}. Removing pid file."
        end
      end
      File.unlink(SOLR_PID_FILE)
      puts "Solr shutdown successfully." if killed
    else
      puts "PID file not found at #{SOLR_PID_FILE}. Either Solr is not running or no PID file was written."
    end
  end

  desc 'Restart Solr. Specify the environment by using: RAILS_ENV=your_env. Defaults to development if none.'
  task :restart => :environment do
    Rake::Task["solr:stop"].invoke 
    Rake::Task["solr:start"].invoke 
  end
  
  desc 'Remove Solr index'
  task :destroy_index => :environment do
    require File.expand_path("#{File.dirname(__FILE__)}/../../config/solr_environment")
    raise "In production mode.  I'm not going to delete the index, sorry." if ENV['RAILS_ENV'] == "production"
    if File.exists?("#{SOLR_DATA_PATH}")
      Dir["#{SOLR_DATA_PATH}/index/*"].each{|f| File.unlink(f) if File.exists?(f)}
      Dir.rmdir("#{SOLR_DATA_PATH}/index")
      puts "Index files removed under " + ENV['RAILS_ENV'] + " environment"
    end
  end
  
  # this task is by Henrik Nyh
  # http://henrik.nyh.se/2007/06/rake-task-to-reindex-models-for-acts_as_solr
  desc %{Reindexes data for all acts_as_solr models. Clears index first to get rid of orphaned records and optimizes index afterwards. RAILS_ENV=your_env to set environment. ONLY=book,person,magazine to only reindex those models; EXCEPT=book,magazine to exclude those models. START_SERVER=true to solr:start before and solr:stop after. BATCH=123 to post/commit in batches of that size: default is 300. CLEAR=false to not clear the index first; OPTIMIZE=false to not optimize the index afterwards.}
  task :reindex => :environment do
    require File.expand_path("#{File.dirname(__FILE__)}/../../config/solr_environment")

    includes = env_array_to_constants('ONLY')
    if includes.empty?
      includes = Dir.glob("#{RAILS_ROOT}/app/models/*.rb").map { |path| File.basename(path, ".rb").camelize.constantize }
    end
    excludes = env_array_to_constants('EXCEPT')
    includes -= excludes
    
    optimize            = env_to_bool('OPTIMIZE',     true)
    start_server        = env_to_bool('START_SERVER', false)
    clear_first         = env_to_bool('CLEAR',       true)
    batch_size          = ENV['BATCH'].to_i.nonzero? || 300
    debug_output        = env_to_bool("DEBUG", false)

    RAILS_DEFAULT_LOGGER.level = ActiveSupport::BufferedLogger::INFO unless debug_output

    if start_server
      puts "Starting Solr server..."
      Rake::Task["solr:start"].invoke 
    end
    
    # Disable solr_optimize
    module ActsAsSolr::CommonMethods
      def blank() end
      alias_method :deferred_solr_optimize, :solr_optimize
      alias_method :solr_optimize, :blank
    end
    
    models = includes.select { |m| m.respond_to?(:rebuild_solr_index) }    
    models.each do |model|
  
      if clear_first
        puts "Clearing index for #{model}..."
        ActsAsSolr::Post.execute(Solr::Request::Delete.new(:query => "#{model.solr_configuration[:type_field]}:#{Solr::Util.query_parser_escape(model.name)}"))
        ActsAsSolr::Post.execute(Solr::Request::Commit.new)
      end
      
      puts "Rebuilding index for #{model}..."
      model.rebuild_solr_index(batch_size)

    end 

    if models.empty?
      puts "There were no models to reindex."
    elsif optimize
      puts "Optimizing..."
      models.last.deferred_solr_optimize
    end

    if start_server
      puts "Shutting down Solr server..."
      Rake::Task["solr:stop"].invoke 
    end
    
  end
  
  def env_array_to_constants(env)
    env = ENV[env] || ''
    env.split(/\s*,\s*/).map { |m| m.singularize.camelize.constantize }.uniq
  end
  
  def env_to_bool(env, default)
    env = ENV[env] || ''
    case env
      when /^true$/i then true
      when /^false$/i then false
      else default
    end
  end

end

