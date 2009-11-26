class DynamicAttribute < ActiveRecord::Base
  belongs_to :dynamicable, :polymorphic => true
end
