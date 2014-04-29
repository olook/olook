class AddIndexOnHighlightCampaigns < ActiveRecord::Migration
  def up
    add_index :highlight_campaigns, :label
  end

  def down
    remove_index :highlight_campaigns, :label
  end
end
