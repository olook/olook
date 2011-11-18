class Order < ActiveRecord::Base
  DEFAULT_QUANTITY = 1
  belongs_to :user
  has_many :variants, :through => :line_items
  has_many :line_items
  delegate :name, :to => :user, :prefix => true
  delegate :email, :to => :user, :prefix => true

  def add_variant(variant, quantity = Order::DEFAULT_QUANTITY)
    if variant.available?
      current_item = line_items.select { |item| item.variant == variant }.first
      if current_item
        current_item.increment!(:quantity, quantity)
      else
        line_items << LineItem.new(:order_id => id, :variant_id => variant.id, :quantity => quantity)
      end
      current_item
    end
  end

  #this should be hard coded now
  def total
    25.90
  end
end
