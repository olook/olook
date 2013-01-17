class ChangeTurnedUserOnCampaignEmail < ActiveRecord::Migration
  def change
    rename_column :campaign_emails, :turned_user, :converted_user
  end
end
