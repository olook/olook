class AddUtmsToCampaignEmail < ActiveRecord::Migration
  def change
    add_column :campaign_emails, :utm_source, :string

    add_column :campaign_emails, :utm_medium, :string

    add_column :campaign_emails, :utm_content, :string

    add_column :campaign_emails, :utm_campaign, :string

  end
end
