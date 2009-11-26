module ActiveRecord
  module Acts
    module DynamicAttributesOn
      def self.included(base)
        base.extend(ClassMethods)
      end
      
      module ClassMethods
        def acts_as_dynamic_attributes
          self.class_eval do
            has_many :dynamic_attributes, :as => "dynamicable"
          end
        end
      end
    end
  end
end