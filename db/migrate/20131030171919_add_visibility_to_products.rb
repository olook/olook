class AddVisibilityToProducts < ActiveRecord::Migration
  def up
    add_column :products, :visibility, :integer, :default => 1
  end

  def down
    remove_column :products, :visibility
  end
end
