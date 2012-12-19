class CreateFreebieVariants < ActiveRecord::Migration
  def change
    create_table :freebie_variants do |t|
      t.integer :variant_id
      t.integer :freebie_id

      t.timestamps
    end
  end
end
