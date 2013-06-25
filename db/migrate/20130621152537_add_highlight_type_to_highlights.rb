class AddHighlightTypeToHighlights < ActiveRecord::Migration
  def change
    add_column :highlights, :highlight_type, :integer
  end
end
