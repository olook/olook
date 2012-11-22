class AddDefaultToProccessOnBraspagCaptureResponses < ActiveRecord::Migration
  def change
    change_column :braspag_capture_responses, :processed, :boolean, :default=>0
  end
end
