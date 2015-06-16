class ChangeIdToBigint < ActiveRecord::Migration
  def up
    change_column :products, :id, 'bigint not null auto_increment'
  end

  def down
    raise ActiveRecord::IrreversibleMigration.new "Destroy info"
  end
end
