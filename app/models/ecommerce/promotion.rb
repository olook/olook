class Promotion < ActiveRecord::Base
  validates_presence_of :name, :discount_percent, :priority
  validates_uniqueness_of :priority

  scope :active, where(:active => true)

  def self.purchases_amount
    Promotion.find_by_strategy("purchases_amount_strategy")
  end

  def load_strategy
    "Promotions::#{self.strategy.to_s.camelize}".constantize
  end
end
