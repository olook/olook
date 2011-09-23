class RenameColumnInQuestion < ActiveRecord::Migration
  def up
    rename_column :questions, :name, :title
  end

  def down
    rename_column :questions, :title, :name
  end
end
