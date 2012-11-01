class AddErrorMessageToBraspagCallback < ActiveRecord::Migration
  def change
    add_column :braspag_callbacks, :error_message, :string
  end
end
