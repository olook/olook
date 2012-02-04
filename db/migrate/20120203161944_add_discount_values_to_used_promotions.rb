class AddDiscountValuesToUsedPromotions < ActiveRecord::Migration
  def change
    add_column :used_promotions, :discount_percent, :integer
  end
end
