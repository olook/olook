class CreateConsolidatedSells < ActiveRecord::Migration
  def change
    create_table :consolidated_sells do |t|
      t.string :category
      t.date :day
      t.integer :amount
      t.decimal :total
      t.string :subcategory
      t.decimal :total_retail

      t.timestamps
    end
  end
end
