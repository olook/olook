class LineItem < ActiveRecord::Base
  belongs_to :variant
  belongs_to :order
  validates_presence_of :variant_id
  validates_presence_of :order_id
  validates_presence_of :quantity

  delegate :price, :to => :variant

  def total_price
    price * quantity
  end
end
