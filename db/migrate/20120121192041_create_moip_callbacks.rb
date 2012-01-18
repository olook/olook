class CreateMoipCallbacks < ActiveRecord::Migration
  def change
    create_table(:moip_callbacks) do |t|
      t.integer :order_id
      t.string :id_transacao
      t.string :cod_moip
      t.string :tipo_pagamento
      t.string :status_pagamento
      t.timestamps
    end

    add_index :moip_callbacks, :id_transacao
  end
end
