class CreateAdminLandingPages < ActiveRecord::Migration
  def change
    create_table :landing_pages do |t|
      t.string :title_url
      t.string :title
      t.boolean :enabled
      t.string :link_url
      t.string :link_title
      t.string :image

      t.timestamps
    end
    add_index :landing_pages, :title_url
  end
end
