class AddProductIdsToHighlightCampaigns < ActiveRecord::Migration
  def change
    add_column :highlight_campaigns, :product_ids, :string
  end
end
