class RemoveOldTables < ActiveRecord::Migration
  def up
    drop_table :cancellation_reasons
    drop_table :order_events
    drop_table :payment_responses
    # drop_table :shipping_companies
    drop_table :used_coupons
    drop_table :used_promotions
    # drop_table :versions
  end

  def down
  end
end
