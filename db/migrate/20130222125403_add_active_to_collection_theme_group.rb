class AddActiveToCollectionThemeGroup < ActiveRecord::Migration
  def change
    add_column :collection_theme_groups, :active, :boolean, default: false
  end
end
