class AddIndexToMoipCallback < ActiveRecord::Migration
  def change
    add_column :moip_callbacks, :retry, :integer, :default => 0
    add_column :moip_callbacks, :error, :text
    add_index :moip_callbacks, :processed
  end
end