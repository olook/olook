class AddPlacementsToTrackings < ActiveRecord::Migration
  def change
    add_column :trackings, :placement, :string
  end
end
