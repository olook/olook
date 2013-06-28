class CreateHighlightCampaignsProductsTable < ActiveRecord::Migration
  def change
    create_table :highlight_campaigns_products do |t|
      t.belongs_to :highlight_campaigns
      t.belongs_to :products
    end
  end
end
