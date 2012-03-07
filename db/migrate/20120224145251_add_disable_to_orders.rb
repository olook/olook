class AddDisableToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :disable, :boolean, :default => false
  end
end
