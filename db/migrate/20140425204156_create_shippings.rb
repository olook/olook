class CreateShippings < ActiveRecord::Migration
  def change
    create_table :shippings do |t|
      t.string :carrier
      t.string :zip_start
      t.string :zip_end
      t.decimal :cost, :precision => 8, :scale => 2
      t.integer :delivery_time
      t.decimal :income, :precision => 8, :scale => 2

      t.timestamps
    end
  end
end
