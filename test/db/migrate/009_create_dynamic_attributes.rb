class CreateDynamicAttributes < ActiveRecord::Migration
  def self.up
    create_table :dynamic_attributes do |t|
      t.integer :dynamicable_id
      t.string  :dynamicable_type
      t.string :name
      t.text :value
      t.timestamps
    end
  end

  def self.down
    drop_table :dynamic_attributes
  end
end
