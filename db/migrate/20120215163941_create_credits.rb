# -*- encoding : utf-8 -*-
class CreateCredits < ActiveRecord::Migration
  def change
    create_table :credits do |t|
      t.string :source
      t.decimal :value, :precision => 10, :scale => 2
      t.integer :multiplier
      t.decimal :total, :precision => 10, :scale => 2
      t.references :user
      t.references :order

      t.timestamps
    end
    add_index :credits, :user_id
    add_index :credits, :order_id
    add_index :credits, :source
  end
end