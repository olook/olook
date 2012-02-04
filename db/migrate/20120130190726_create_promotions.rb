class CreatePromotions < ActiveRecord::Migration
  def change
    create_table :promotions do |t|
      t.string :name
      t.string :description
      t.string :strategy
      t.integer :priority
      t.integer :discount_percent
      t.boolean :active

      t.timestamps
    end
  end
end
