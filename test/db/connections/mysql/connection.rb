require 'logger'
ActiveRecord::Base.logger = Logger.new("debug.log")

ActiveRecord::Base.establish_connection(
  :adapter  => "mysql",
  :username => "root",
  :password => "rotz2od",
  :encoding => "utf8",
  :database => "actsassolr_test"
)

