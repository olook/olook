class AddBannerImageToHighlights < ActiveRecord::Migration
  def change
    add_column :highlights, :banner_image, :string
  end
end
