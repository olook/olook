class AddIndexesToBraspagRelatedTables < ActiveRecord::Migration
  def change
    add_index :braspag_capture_responses, :order_id
    add_index :braspag_authorize_responses, :order_id
  end
end
