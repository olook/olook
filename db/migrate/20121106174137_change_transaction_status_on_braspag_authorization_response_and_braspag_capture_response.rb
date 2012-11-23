class ChangeTransactionStatusOnBraspagAuthorizationResponseAndBraspagCaptureResponse < ActiveRecord::Migration
  def change
    rename_column :braspag_authorize_responses, :transaction_status, :status
  end
end
