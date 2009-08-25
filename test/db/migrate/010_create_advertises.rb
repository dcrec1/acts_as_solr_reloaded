class CreateAdvertises < ActiveRecord::Migration
  def self.up
    create_table :advertises do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :advertises
  end
end
