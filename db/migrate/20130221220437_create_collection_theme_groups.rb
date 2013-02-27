class CreateCollectionThemeGroups < ActiveRecord::Migration
  def change
    create_table :collection_theme_groups do |t|
      t.string :name
      t.integer :position

      t.timestamps
    end
  end
end
