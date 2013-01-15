class AddTurnedUserToCampaignEmail < ActiveRecord::Migration
  def change
    add_column :campaign_emails, :turned_user, :boolean, :default => 0
  end
end
