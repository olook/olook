class ChangeDimensionFieldsToDecimalOnVariants < ActiveRecord::Migration
  def change
    change_column :variants, :width , :decimal, :precision => 8, :scale => 2
    change_column :variants, :height, :decimal, :precision => 8, :scale => 2
    change_column :variants, :length, :decimal, :precision => 8, :scale => 2
  end
end
