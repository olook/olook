class AddCampaignEmailCreatedAtToUsers < ActiveRecord::Migration
  def change
    add_column :users, :campaign_email_created_at, :datetime, null: true
  end
end
