class AddTotalPaidToPayments < ActiveRecord::Migration
  def change
    add_column :payments, :total_paid, :decimal, :precision => 8, :scale => 2 
  end
end
