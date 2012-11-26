class AddIndexOnCampaignEmails < ActiveRecord::Migration
  def change
    change_table :campaign_emails do |t|
      t.index :email
    end
  end
end
