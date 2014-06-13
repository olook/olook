class AddSubcategoryAndColorToProductInterests < ActiveRecord::Migration
  def change
    add_column :product_interests, :subcategory, :string
    add_column :product_interests, :color, :string
  end
end
