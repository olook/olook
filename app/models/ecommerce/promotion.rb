class Promotion < ActiveRecord::Base
  validates_presence_of :name, :discount_percent, :priority, :banner_label
  validates_uniqueness_of :priority

  scope :active, where(:active => true)

  has_many :promotion_payments

  def self.purchases_amount
    Promotion.find_by_strategy("purchases_amount_strategy")
  end

  def load_strategy(promotion, user)
    case self.strategy
    when "purchases_amount_strategy"
      Promotions::PurchasesAmountStrategy.new(promotion, user)
    when "free_item_strategy"
      Promotions::FreeItemStrategy.new(promotion, user)
    else
      raise "Undefined strategy"
    end
  end

end
