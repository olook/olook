class RemoveActiveFromCollectionThemeGroups < ActiveRecord::Migration
  def up
    remove_column :collection_theme_groups, :active
      end

  def down
    add_column :collection_theme_groups, :active, :boolean
  end
end
