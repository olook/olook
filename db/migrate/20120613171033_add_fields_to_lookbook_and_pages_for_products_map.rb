class AddFieldsToLookbookAndPagesForProductsMap < ActiveRecord::Migration
  def change
    add_column :lookbooks, :image_icon, :string
    add_column :lookbooks, :image_icon_over, :string
    
    
  end
end
