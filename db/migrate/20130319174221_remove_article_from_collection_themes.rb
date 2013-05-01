class RemoveArticleFromCollectionThemes < ActiveRecord::Migration
  def up
    remove_column :collection_themes, :article
  end

  def down
    add_column :collection_themes, :article, :string
  end
end
