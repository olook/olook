# -*- encoding : utf-8 -*-
class CreatePictures < ActiveRecord::Migration
  def change
    create_table :pictures do |t|
      t.string :image
      t.string :display_on
      t.belongs_to :product

      t.timestamps
    end
    add_index :pictures, :product_id
  end
end
