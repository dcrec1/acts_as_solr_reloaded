module ActiveRecord
  module Acts
    module LocalOn
      def self.included(base)
        base.extend(ClassMethods)
      end
      
      module ClassMethods
        def acts_as_local
          self.class_eval do
            has_one :local, :as => "localizable"
          end
        end
      end
    end
  end
end