class AddCampaignDescriptionToCoupons < ActiveRecord::Migration
  def change
    add_column :coupons, :campaign_description, :string

  end
end
