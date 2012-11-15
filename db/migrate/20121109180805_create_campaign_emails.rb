class CreateCampaignEmails < ActiveRecord::Migration
  def change
  	drop_table :campaign_emails
    create_table :campaign_emails do |t|
      t.string :email

      t.timestamps
    end
  end
end
