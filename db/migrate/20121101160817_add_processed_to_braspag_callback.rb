class AddProcessedToBraspagCallback < ActiveRecord::Migration
  def change
    add_column :braspag_callbacks, :processed, :boolean, :default => false

  end
end
