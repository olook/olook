class CreateCampaignPages < ActiveRecord::Migration
  def change
    create_table :campaign_pages do |t|
      t.integer :campaign_id
      t.integer :page_id

      t.timestamps
    end
  end
end
