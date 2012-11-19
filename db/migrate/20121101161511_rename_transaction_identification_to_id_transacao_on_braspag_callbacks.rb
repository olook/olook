class RenameTransactionIdentificationToIdTransacaoOnBraspagCallbacks < ActiveRecord::Migration
  def change
    change_table :braspag_callbacks do |t|
      t.rename :transaction_identification, :id_transacao
    end
  end
end
