class AddCheckoutBannerInPromotions < ActiveRecord::Migration
  def up
    add_column :promotions, :checkout_banner, :string
  end

  def down
    remove_column :promotions, :checkout_banner
  end
end
