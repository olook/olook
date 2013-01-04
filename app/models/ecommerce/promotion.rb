class Promotion < ActiveRecord::Base
  validates_presence_of :name, :banner_label

  scope :active, where(:active => true)

  has_many :promotion_payments

  def self.purchases_amount
    Promotion.find_by_strategy("purchases_amount_strategy")
  end

  def load_strategy(promotion, user)
    Promotions::PurchasesAmountStrategy.new(promotion, user)
  end
end
