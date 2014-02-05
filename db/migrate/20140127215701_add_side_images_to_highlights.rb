class AddSideImagesToHighlights < ActiveRecord::Migration
  def change
    add_column :highlights, :left_image, :string
    add_column :highlights, :right_image, :string
  end
end
