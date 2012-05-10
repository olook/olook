class AddHeaderImageToMoments < ActiveRecord::Migration
  def change
    add_column :moments, :header_image, :string

  end
end
