class AddIsVisibleToProducts < ActiveRecord::Migration
  def change
    add_column :products, :is_visible, :boolean
  end
end
