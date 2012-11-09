class AddRetriesToBraspagCaptureResponse < ActiveRecord::Migration
  def change
    add_column :braspag_capture_responses, :retries, :integer, :default => 0

  end
end
