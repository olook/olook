class AddFieldsToLookbookAndPagesForProductsMap < ActiveRecord::Migration
  def change
    add_column :lookbooks, :icon, :string
    add_column :lookbooks, :icon_over, :string
  end
end
