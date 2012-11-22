class AddOrderIdToBraspagCaptureResponse < ActiveRecord::Migration
  def change
    add_column :braspag_capture_responses, :order_id, :string

  end
end
