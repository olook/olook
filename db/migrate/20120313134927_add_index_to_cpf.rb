class AddIndexToCpf < ActiveRecord::Migration
  def change
    add_index :users, :cpf
  end
end
