class CreateLookbooks < ActiveRecord::Migration
  def change
    create_table :lookbooks do |t|
      t.string :name
      t.string :thumb_image

      t.timestamps
    end
  end
end
