class AddAltTextToHighlights < ActiveRecord::Migration
  def change
    add_column :highlights, :alt_text, :string
  end
end
