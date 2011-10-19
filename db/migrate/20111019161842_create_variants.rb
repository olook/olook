class CreateVariants < ActiveRecord::Migration
  def change
    create_table :variants do |t|
      t.references :product
      t.string :number
      t.string :description
      t.string :display_reference
      t.float :price
      t.integer :inventory

      t.timestamps
    end
    add_index :variants, :product_id
  end
end
