class AddPercentToPayment < ActiveRecord::Migration
  def change
    add_column :payments, :percent, :decimal, :precision => 3, :scale => 2
    add_index :payments, :percent
    add_column :orders, :gross_amount, :decimal, :precision => 8, :scale => 2
  end
end