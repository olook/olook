class CreateCeps < ActiveRecord::Migration
  def change
    create_table :ceps do |t|
      t.string :cep
      t.string :endereco
      t.string :bairro
      t.string :cidade
      t.string :estado
      t.string :nome_estado

      t.timestamps
    end
  end
end
