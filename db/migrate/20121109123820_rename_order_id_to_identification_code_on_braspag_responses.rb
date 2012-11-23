class RenameOrderIdToIdentificationCodeOnBraspagResponses < ActiveRecord::Migration
  def change
    rename_column :braspag_authorize_responses, :order_id, :identification_code
    rename_column :braspag_capture_responses, :order_id, :identification_code
  end
end
