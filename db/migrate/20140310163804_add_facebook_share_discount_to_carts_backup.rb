class AddFacebookShareDiscountToCartsBackup < ActiveRecord::Migration
  def change
    add_column :carts_backup, :facebook_share_discount, :boolean
  end
end