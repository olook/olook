class AddRetailPriceToVariant < ActiveRecord::Migration
  def change
    add_column :variants, :retail_price, :decimal, :precision => 10, :scale => 2
    add_index :variants, :is_master
    add_index :variants, [:product_id, :is_master]
  end
end