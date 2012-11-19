class DropBraspagResponse < ActiveRecord::Migration
  def down
    drop_table :braspag_responses
  end
end