class AddColorCategoryToProduct < ActiveRecord::Migration
  def change
    add_column :products, :color_category, :string

  end
end
