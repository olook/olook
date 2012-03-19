class LineItem < ActiveRecord::Base
  belongs_to :variant
  belongs_to :order
  validates_presence_of :variant_id
  validates_presence_of :order_id
  validates_presence_of :quantity
  scope :ordered_by_price, order('line_items.price DESC')
  delegate :liquidation?, :to => :variant

  def total_price
    variant.liquidation? ? (retail_price * quantity) : (price * quantity)
  end
end
