class CreateBrands < ActiveRecord::Migration
  def change
    create_table :brands do |t|
      t.string :name
      t.string :header_image
      t.string :header_image_alt

      t.timestamps
    end
  end
end
