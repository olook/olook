class AddUsedAmountToCoupons < ActiveRecord::Migration
  def change
    add_column :coupons, :used_amount, :integer, :default => 0
  end
end
