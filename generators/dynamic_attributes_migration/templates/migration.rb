class DynamicAttributesMigration < ActiveRecord::Migration
  def self.up
    create_table :dynamic_attributes do |t|
      t.integer :dynamicable_id
      t.string  :dynamicable_type
      t.string :name
      t.text :value
      t.timestamps
    end
    add_index :dynamic_attributes, [:dynamicable_id, :dynamicable_type, :name], :unique => true,  :name => 'da_pk'
  end

  def self.down
    remove_index 'da_pk'
    drop_table :dynamic_attributes
  end
end
