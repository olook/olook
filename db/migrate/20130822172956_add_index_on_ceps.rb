class AddIndexOnCeps < ActiveRecord::Migration
  def up
    # add_index :ceps, :cep, :unique => true
  end

  def down
    remove_index :ceps, :cep
  end
end
