class CreateFreightPrices < ActiveRecord::Migration
  def change
    create_table :freight_prices do |t|
      t.belongs_to :shipping_company
      t.string :zip_start
      t.string :zip_end
      t.decimal :weight_start, :precision => 8, :scale => 3
      t.decimal :weight_end, :precision => 8, :scale => 3
      t.integer :delivery_time
      t.decimal :price, :precision => 8, :scale => 2
      t.decimal :cost, :precision => 8, :scale => 2
      t.string :description

      t.timestamps
    end
  end
end
