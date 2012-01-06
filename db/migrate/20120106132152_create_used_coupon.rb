class CreateUsedCoupon < ActiveRecord::Migration
  def change
    create_table :used_coupons do |t|
      t.integer :order_id
      t.integer :coupon_id
      t.timestamps
    end
  end
end
