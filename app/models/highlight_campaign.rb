class HighlightCampaign < ActiveRecord::Base
  attr_accessible :label, :product_ids
  validates :label, presence: true

  def campaign_products
    if campaign_name.present? && campaign = HighlightCampaign.find_by_label(campaign_name)
      SearchEngine.new(product_id: campaign.product_ids).with_limit(1000)
    else
      []      
    end
  end

end
