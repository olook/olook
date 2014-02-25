class CreateUserCoupons < ActiveRecord::Migration
  def change
    create_table :user_coupons do |t|
      t.references :user
      t.text :coupon_ids

      t.timestamps
    end
    add_index :user_coupons, :user_id
  end
end
