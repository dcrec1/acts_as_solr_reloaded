class CreateDynamicAttributes < ActiveRecord::Migration
  def self.up
    create_table :dynamic_attributes do |t|
      t.references :advertise
      t.string :name
      t.string :value

      t.timestamps
    end
  end

  def self.down
    drop_table :dynamic_attributes
  end
end
