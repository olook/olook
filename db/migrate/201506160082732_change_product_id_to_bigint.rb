class ChangeProductIdToBigint < ActiveRecord::Migration
  def up
    change_column :collection_themes_products, :product_id, 'bigint'
    change_column :catalog_products, :product_id, 'bigint'
    change_column :consolidated_sells, :product_id, 'bigint'
    change_column :details, :product_id, 'bigint'
    change_column :gift_boxes_products, :product_id, 'bigint'
    change_column :liquidation_carousels, :product_id, 'bigint'
    change_column :liquidation_previews, :product_id, 'bigint'
    change_column :liquidation_products, :product_id, 'bigint'
    change_column :pictures, :product_id, 'bigint'
    change_column :product_interests, :product_id, 'bigint'
    change_column :product_price_logs, :product_id, 'bigint'
    change_column :variants, :product_id, 'bigint'

    change_column :variants, :id, 'bigint not null auto_increment'
    change_column :catalog_products, :variant_id, 'bigint'
    change_column :freebie_variants, :variant_id, 'bigint'
    change_column :line_items, :variant_id, 'bigint'
    change_column :liquidation_products, :variant_id, 'bigint'
    change_column :wished_products, :variant_id, 'bigint'
  end

  def down
    raise ActiveRecord::IrreversibleMigration.new "Destroy info"
  end
end
