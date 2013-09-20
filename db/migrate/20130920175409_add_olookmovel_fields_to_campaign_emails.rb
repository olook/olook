class AddOlookmovelFieldsToCampaignEmails < ActiveRecord::Migration
  def change
    add_column :campaign_emails, :phone, :string
    add_column :campaign_emails, :profile, :string
  end
end
