class ChangeThePrecisionDiscountValueOfUsedPromotions < ActiveRecord::Migration
  def change
    change_column :used_promotions, :discount_value, :decimal, :precision => 10, :scale => 2
  end
end
