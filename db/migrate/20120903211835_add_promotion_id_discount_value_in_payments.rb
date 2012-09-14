class AddPromotionIdDiscountValueInPayments < ActiveRecord::Migration
  def up
    add_column :payments, :promotion_id, :integer
    add_column :payments, :discount_percent, :integer
    add_index :payments, :promotion_id
  end

  def down
    
  end
end