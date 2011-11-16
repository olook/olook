class AddIsMasterDimensionsAndWeightFieldsToVariant < ActiveRecord::Migration
  def change
    add_column :variants, :is_master, :boolean
    add_column :variants, :width, :integer
    add_column :variants, :height, :integer
    add_column :variants, :length, :integer
    add_column :variants, :weight, :decimal, :precision => 8, :scale => 2
  end
end
