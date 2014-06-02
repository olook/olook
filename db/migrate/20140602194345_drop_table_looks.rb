class DropTableLooks < ActiveRecord::Migration
  def up
    drop_table :looks
  end

  def down
    raise ActiveRecord::IrreversibleMigration.new("Can't create looks table again")
  end
end
