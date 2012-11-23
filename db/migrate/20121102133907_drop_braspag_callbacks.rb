class DropBraspagCallbacks < ActiveRecord::Migration
  def up
    drop_table :braspag_callbacks
  end

  def down
  end
end
