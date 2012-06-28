class AddClassificacaoToMoipCallbacks < ActiveRecord::Migration
  def change
    add_column :moip_callbacks, :classificacao, :string

  end
end
