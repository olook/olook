class RemoveCouponFromCart < ActiveRecord::Migration
  def change
    remove_column :carts, :coupon
  end
end
