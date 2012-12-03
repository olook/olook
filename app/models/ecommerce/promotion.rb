# == Schema Information
#
# Table name: promotions
#
#  id               :integer          not null, primary key
#  name             :string(255)
#  description      :string(255)
#  strategy         :string(255)
#  priority         :integer
#  discount_percent :integer
#  active           :boolean
#  created_at       :datetime
#  updated_at       :datetime
#  param            :string(255)
#  my_order_label   :string(255)
#  cart_label       :string(255)
#  banner_label     :string(255)
#

class Promotion < ActiveRecord::Base
  validates_presence_of :name, :discount_percent, :priority, :banner_label
  validates_uniqueness_of :priority

  scope :active, where(:active => true)

  has_many :promotion_payments

  def self.purchases_amount
    Promotion.find_by_strategy("purchases_amount_strategy")
  end

  def load_strategy
    "Promotions::#{self.strategy.to_s.camelize}".constantize
  end
end
