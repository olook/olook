class AddIndexToCampaigns < ActiveRecord::Migration
  def change
    add_index :campaigns, [:start_at, :end_at]
  end
end
