module ActsAsSolr
  module MongoMapper
    def self.included(clazz)
      clazz.extend ActsAsSolr::ActsMethods
      clazz.extend ClassMethods
    end
    
    module ClassMethods
      def columns_hash
        keys
      end
      
      def primary_key
        'id'
      end
      
      def find(*args)
        if args.first.instance_of? Array
          ids = args.first.map { |id| Mongo::ObjectID.from_string(id) }
          super :all, :conditions => {primary_key => ids}
        else
          super *args
        end
      end
    end
  end
end
