# -*- encoding : utf-8 -*-
class CreateDetails < ActiveRecord::Migration
  def change
    create_table :details do |t|
      t.references :product
      t.string :translation_token
      t.text :description
      t.integer :display_on

      t.timestamps
    end
  end
end
