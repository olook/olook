class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.string :image
      t.belongs_to :lookbook

      t.timestamps
    end
    add_index :images, :lookbook_id
  end
end