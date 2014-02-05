class AddMercadoPagoIdToPayments < ActiveRecord::Migration
  def change
    add_column :payments, :mercado_pago_id, :string
  end
end