class AddLabelsToPromotions < ActiveRecord::Migration
  def change
    add_column :promotions, :my_order_label, :string
    add_column :promotions, :cart_label, :string
  end
end
