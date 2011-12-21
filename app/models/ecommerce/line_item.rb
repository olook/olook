class LineItem < ActiveRecord::Base
  PRICE_FOR_GIFT = 0.01
  belongs_to :variant
  belongs_to :order
  validates_presence_of :variant_id
  validates_presence_of :order_id
  validates_presence_of :quantity
  scope :ordered_by_price, order('line_items.price DESC')

  def price
    (self.gift?) ? PRICE_FOR_GIFT : read_attribute(:price)
  end

  def total_price
    price * quantity
  end
end
