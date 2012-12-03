class ChangeCorrelationIdOnBraspagAuthorizationResponse < ActiveRecord::Migration
  def change
    change_column :braspag_authorize_responses, :correlation_id, :string
  end
end