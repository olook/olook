class AddInvoiceSerieToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :invoice_serie, :string
  end
end
