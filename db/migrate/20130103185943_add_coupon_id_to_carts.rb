class AddCouponIdToCarts < ActiveRecord::Migration
  def change
    add_column :carts, :coupon_id, :integer
    add_index :carts, :coupon_id
  end
end
