class ChangeColumnsOnBraspagResponses < ActiveRecord::Migration
  def self.table_exists?(braspag_responses)
    change_column :braspag_responses, :braspag_order_id, :string
    change_column :braspag_responses, :braspag_transaction_id, :string
    change_column :braspag_responses, :amount, :string
    change_column :braspag_responses, :amount, :string
    remove_column :braspag_responses, :error_code
  end
end
