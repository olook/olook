class CreateCatalogHeaders < ActiveRecord::Migration
  def change
    create_table :catalog_headers do |t|
      t.string :url
      t.string :type
      t.string :h1
      t.string :h2
      t.string :small_banner1
      t.string :alt_small_banner1
      t.string :link_small_banner1
      t.string :small_banner2
      t.string :alt_small_banner2
      t.string :link_small_banner2
      t.string :medium_banner
      t.string :alt_medium_banner
      t.string :link_medium_banner
      t.string :big_banner
      t.string :alt_big_banner
      t.string :link_big_banner
      t.string :title
      t.string :resume_title
      t.text :text_complement

      t.timestamps
    end
  end
end
