class RenameColorCodeToColorSampleOnProducts < ActiveRecord::Migration
  def change
    rename_column :products, :color_code, :color_sample
  end
end
