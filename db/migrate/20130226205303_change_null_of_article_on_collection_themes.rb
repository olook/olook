class ChangeNullOfArticleOnCollectionThemes < ActiveRecord::Migration
  def up
    change_column :collection_themes, :article, :string, null: true, default: nil
  end

  def down
    change_column :collection_themes, :article, :string, :limit => 25, :null => false
  end
end
