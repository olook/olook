class CreateCollectionThemesProducts < ActiveRecord::Migration
  def change
    create_table :collection_themes_products, id: false do |t|
      t.integer :collection_theme_id
      t.integer :product_id
    end
  end
end
