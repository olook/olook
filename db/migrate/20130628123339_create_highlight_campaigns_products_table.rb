class CreateHighlightCampaignsProductsTable < ActiveRecord::Migration
  def change
    create_table :highlight_campaigns_products, id: false do |t|
      t.integer :highlight_campaign_id
      t.integer :product_id
    end
  end
end
