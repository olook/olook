class AddIndexToCouponCode < ActiveRecord::Migration
  def change
    add_index :coupons, :code
  end
end
