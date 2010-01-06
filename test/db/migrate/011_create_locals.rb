class CreateLocals < ActiveRecord::Migration
  def self.up
    create_table :locals do |t|
       t.integer :localizable_id
       t.string  :localizable_type
       t.string :latitude
       t.string :longitude
       t.timestamps
    end
  end

  def self.down
    drop_table :locals
  end
end
