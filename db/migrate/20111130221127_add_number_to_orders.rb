class AddNumberToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :number, :integer, :limit => 8
  end
end
