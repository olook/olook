class AddTitleToHighlights < ActiveRecord::Migration
  def change
    add_column :highlights, :title, :string
    add_column :highlights, :subtitle, :string
  end
end
