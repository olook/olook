class AddCouponToPayments < ActiveRecord::Migration
  def change
    add_column :payments, :coupon_id, :integer
    add_index :payments, :coupon_id
  end
end
