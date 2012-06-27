class AddTrackingCodeToFreights < ActiveRecord::Migration
  def change
    add_column :freights, :tracking_code, :string

  end
end
