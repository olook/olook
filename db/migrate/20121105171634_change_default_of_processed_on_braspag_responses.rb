class ChangeDefaultOfProcessedOnBraspagResponses < ActiveRecord::Migration
  def self.table_exists?(braspag_responses)
    change_column_default :braspag_responses, :processed, false
  end
end
