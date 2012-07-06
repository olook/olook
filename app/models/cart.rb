# -*- encoding : utf-8 -*-
class Cart < ActiveRecord::Base
  belongs_to :user
  has_one :order
  has_many :cart_items
  
  #TODO: refactor this to include price as a parameter
  def add_variant(variant, quantity=nil)
    quantity ||= Order::DEFAULT_QUANTITY.to_i
    quantity = quantity.to_i
    if variant.available_for_quantity?(quantity)
      current_item = line_items.select { |item| item.variant == variant }.first
      if current_item
        current_item.update_attributes(:quantity => quantity)
      else
        current_item =  LineItem.new(:order_id => id,
                                     :variant_id => variant.id,
                                     :quantity => quantity,
                                     :price => variant.price,
                                     :retail_price => variant.product.retail_price
                                     )
        line_items << current_item
      end
      current_item
    end
  end

  def remove_variant(variant)
    current_item = line_items.select { |item| item.variant == variant }.first
    current_item.destroy if current_item
  end
  
  
end