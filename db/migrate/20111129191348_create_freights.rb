class CreateFreights < ActiveRecord::Migration
  def change
    create_table :freights do |t|
      t.decimal :price, :precision => 8, :scale => 2
      t.decimal :cost, :precision => 8, :scale => 2
      t.integer :delivery_time
      t.integer :order_id
    end
  end
end
