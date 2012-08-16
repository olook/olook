class AddColorCategoryToProduct < ActiveRecord::Migration
  def change
    add_column :products, :color_category, :string

    add_index :products, :color_category
  end
end
