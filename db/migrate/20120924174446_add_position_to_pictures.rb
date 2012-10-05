class AddPositionToPictures < ActiveRecord::Migration
  def change
  	add_column :pictures, :position, :integer, default: 100
  	add_index :pictures, :position
  end
end
