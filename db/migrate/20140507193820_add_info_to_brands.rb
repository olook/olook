class AddInfoToBrands < ActiveRecord::Migration
  def change
    add_column :brands, :info, :text
  end
end
