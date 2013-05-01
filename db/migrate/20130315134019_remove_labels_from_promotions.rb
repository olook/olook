class RemoveLabelsFromPromotions < ActiveRecord::Migration
  def up
    remove_column :promotions, :my_order_label
    remove_column :promotions, :cart_label
    remove_column :promotions, :banner_label
  end

  def down
    add_column :promotions, :my_order_label, :string
    add_column :promotions, :cart_label, :string
    add_column :promotions, :banner_label, :string
  end
end
