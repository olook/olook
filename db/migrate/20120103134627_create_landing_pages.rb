class CreateLandingPages < ActiveRecord::Migration
  def change
    create_table :landing_pages do |t|
      t.string :page_url
      t.string :page_title
      t.string :page_image
      t.string :button_url
      t.string :button_alt
      t.string :button_image
      t.boolean :enabled
      t.boolean :show_header
      t.boolean :show_footer

      t.timestamps
    end
    add_index :landing_pages, :page_url
  end
end
