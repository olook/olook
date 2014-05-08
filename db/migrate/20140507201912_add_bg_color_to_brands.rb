class AddBgColorToBrands < ActiveRecord::Migration
  def change
    add_column :brands, :bg_color, :string
    add_column :brands, :font_color, :string
  end
end
