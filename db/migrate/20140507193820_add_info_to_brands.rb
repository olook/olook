class AddInfoToBrands < ActiveRecord::Migration
  def change
    add_column :brands, :info, :string
  end
end
