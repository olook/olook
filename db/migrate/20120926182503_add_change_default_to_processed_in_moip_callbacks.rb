class AddChangeDefaultToProcessedInMoipCallbacks < ActiveRecord::Migration
  def change
    change_column_default :moip_callbacks, :processed, false
  end
end