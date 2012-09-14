class PromotionPayment < Payment
  belongs_to :promotion
  validates :promotion_id, :presence => true
  validates :discount_percent, :presence => true
  
	
end
