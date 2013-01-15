class PromotionPayment < Payment
  belongs_to :promotion
  validates :discount_percent, :presence => true
end
