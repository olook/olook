class ChangeCorrelationIdFromBraspagCaptureResponse < ActiveRecord::Migration
  def up
    change_column :braspag_capture_responses, :correlation_id, :string
  end

  def down
    change_column :braspag_capture_responses, :correlation_id, :integer
  end
end
