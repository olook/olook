# -*- encoding : utf-8 -*-
class Cart < ActiveRecord::Base
  DEFAULT_QUANTITY = 1

  belongs_to :user
  has_many :orders
  has_many :items, :class_name => "CartItem", :dependent => :destroy
  
  def add_item(variant, quantity=nil, gift_position=0, gift=false)
    #BLOCK ADD IF IS NOT GIFT AND HAS GIFT IN CART
    return nil if self.has_gift_items? && !gift

    quantity ||= Cart::DEFAULT_QUANTITY.to_i
    quantity = quantity.to_i

    return nil unless variant.available_for_quantity?(quantity)

    current_item = items.select { |item| item.variant == variant }.first
    if current_item
      current_item.update_attributes(:quantity => quantity)
    else

      current_item =  CartItem.new(:cart_id => id,
                                   :variant_id => variant.id,
                                   :quantity => quantity,
                                   :gift_position => gift_position,
                                   :gift => gift
                                   )
      items << current_item
    end

    current_item
  end

  def remove_item(variant)
    current_item = items.select { |item| item.variant == variant }.first
    current_item.destroy if current_item
    self.reload
    if has_gift_items?
      gift_position = 0
      items.each do |item|
        item.update_attribute(:gift_position, gift_position)
        gift_position += 1
      end
    end
  end
  
  def items_total
   items.sum(:quantity)
  end

  def clear
    items.destroy_all
  end

  def has_gift_items?
    items.where(:gift => true).count > 0
  end
  
  def remove_unavailable_items
    unavailable_items = []
    items.each do |li|
      item = CartItem.lock("FOR UPDATE").find(li.id)
      unavailable_items << item unless item.variant.available_for_quantity? item.quantity
    end
    size_items = unavailable_items.size
    unavailable_items.each {|item| item.destroy}
    size_items
  end
end
