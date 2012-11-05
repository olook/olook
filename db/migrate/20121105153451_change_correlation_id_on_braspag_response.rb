class ChangeCorrelationIdOnBraspagResponse < ActiveRecord::Migration
  
  def change
    change_column :braspag_responses, :correlation_id, :string
  end

end
