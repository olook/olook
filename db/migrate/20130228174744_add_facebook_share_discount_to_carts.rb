class AddFacebookShareDiscountToCarts < ActiveRecord::Migration
  def change
    add_column :carts, :facebook_share_discount, :boolean
  end
end
