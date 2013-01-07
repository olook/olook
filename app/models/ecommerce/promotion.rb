class Promotion < ActiveRecord::Base
  validates_presence_of :name, :banner_label

  scope :active, where(:active => true)

  has_many :promotion_payments

  has_many :rules_parameters
  has_many :promotion_rules, :through => :rules_parameters

  accepts_nested_attributes_for :promotion_rules

  def self.purchases_amount
    #Promotion.find_by_strategy("purchases_amount_strategy")
    first
  end

  def load_strategy(promotion, user)
    Promotions::PurchasesAmountStrategy.new(promotion, user)
  end
end
