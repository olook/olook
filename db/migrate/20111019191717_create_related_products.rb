# -*- encoding : utf-8 -*-
class CreateRelatedProducts < ActiveRecord::Migration
  def change
    create_table :related_products do |t|
      t.column :product_a_id, :integer, :null => false
      t.column :product_b_id, :integer, :null => false

      t.timestamps
    end
    add_index :related_products, :product_a_id
    add_index :related_products, :product_b_id
  end
end
