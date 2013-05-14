class ChangeModalCouponField < ActiveRecord::Migration
  def change
    change_column :coupons, :modal, :integer, default: 1
  end
end
