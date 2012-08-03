class AddCampaignToCoupons < ActiveRecord::Migration
  def change
    add_column :coupons, :campaign, :string

  end
end
