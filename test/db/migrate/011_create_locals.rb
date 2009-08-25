class CreateLocals < ActiveRecord::Migration
  def self.up
    create_table :locals do |t|
      t.string :longitude
      t.string :latitude
      t.references :advertise
      
      t.timestamps
    end
  end

  def self.down
    drop_table :locals
  end
end
