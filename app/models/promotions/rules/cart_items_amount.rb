# -*- encoding : utf-8 -*-
class CartItemsAmount < PromotionRule

  def matches?(cart, promotion)
    quantity_of_items(cart) % self.param_for(promotion) == 0
  end
  
  private
    def quantity_of_items cart
      cart.items.inject(0) { |amount, item| amount += item.quantity }
    end
end
