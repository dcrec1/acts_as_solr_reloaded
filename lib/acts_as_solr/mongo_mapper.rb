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

      def merge_conditions(*args)
        ret = {}
        args.each{ |a| ret.merge!(a) if a.is_a?(Hash) }
        ret
      end
    end
  end
end
