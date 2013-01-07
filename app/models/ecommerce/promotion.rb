class Promotion < ActiveRecord::Base
  validates_presence_of :name, :banner_label

  scope :active, where(:active => true)
  scope :active_and_not_expired, lambda {|date| active.where('starts_at < :date AND ends_at > :date', date: date)}

  has_many :promotion_payments

  has_many :rules_parameters
  has_many :promotion_rules, :through => :rules_parameters
  # has_many :promotion_actions

  accepts_nested_attributes_for :promotion_rules

  def apply cart
    # TODO REFACTOR THIS!!!!!
    # => export this logic to PromotionAction class
    cart.items.each do |cart_item|
      sub_total = cart_item.quantity * cart_item.price
      adjust = sub_total * BigDecimal("0.20")
      cart_item.adjustment.update_attributes(:value => adjust)
    end
  end

  def self.purchases_amount
    #Promotion.find_by_strategy("purchases_amount_strategy")
    first
  end

  def load_strategy(promotion, user)
    Promotions::PurchasesAmountStrategy.new(promotion, user)
  end
end
