class RemoveLightBoxFromCampaigns < ActiveRecord::Migration
  def up
    remove_column :campaigns, :lightbox
      end

  def down
    add_column :campaigns, :lightbox, :string
  end
end
