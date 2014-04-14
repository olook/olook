class CreateMktSettings < ActiveRecord::Migration
  def self.up
    create_table :mkt_settings do |t|
      t.string :var, :null => false
      t.text   :value, :null => true
      t.integer :thing_id, :null => true
      t.string :thing_type, :limit => 30, :null => true
      t.timestamps
    end
    
    add_index :mkt_settings, [ :thing_type, :thing_id, :var ], :unique => true
  end

  def self.down
    drop_table :mkt_settings
  end
end
