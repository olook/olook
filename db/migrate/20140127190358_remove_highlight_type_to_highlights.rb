class RemoveHighlightTypeToHighlights < ActiveRecord::Migration
  def up
    remove_column :highlights, :highlight_type
  end

  def down
    add_column :highlights, :highlight_type, :integer
  end
end
