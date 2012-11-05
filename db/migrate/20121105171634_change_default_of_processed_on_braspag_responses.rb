class ChangeDefaultOfProcessedOnBraspagResponses < ActiveRecord::Migration
  def change
    change_column_default :braspag_responses, :processed, false
  end
end
