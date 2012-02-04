class CreateUsedPromotions < ActiveRecord::Migration
  def change
    create_table :used_promotions do |t|
      t.references :order
      t.references :promotion
      t.decimal :discount_value

      t.timestamps
    end
    add_index :used_promotions, :order_id
    add_index :used_promotions, :promotion_id
  end
end
