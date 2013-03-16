class RemoveIndexOnNameForCollectionThemes < ActiveRecord::Migration
  def up
    remove_index :collection_themes, name: 'index_moments_on_name'
  end

  def down
    add_index :collection_themes, name: 'index_moments_on_name'
  end
end
