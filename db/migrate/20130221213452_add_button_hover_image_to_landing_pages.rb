class AddButtonHoverImageToLandingPages < ActiveRecord::Migration
  def change
    add_column :landing_pages, :button_hover_image, :string
  end
end
