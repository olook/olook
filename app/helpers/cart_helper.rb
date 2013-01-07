# -*- encoding : utf-8 -*-
module CartHelper

  def print_credit_message
    "(não podem ser utilizados em pedidos com desconto)" unless @cart_service.allow_credit_payment?
  end

  def total_user_credits
    return @user.current_credit if @cart_service.allow_credit_payment?
    @user.user_credits_for(:redeem).total
  end

  def promotion_discount(item)
    # TODO remove this hardcoding
    number_to_percentage(20, :precision => 0)
    # if @cart_service.item_retail_price_total(item) == 0
    #   "Grátis"
    # else
    #   number_to_percentage(@cart_service.item_discount_percent(item), :precision => 0)
    # end
  end

  def remaining_items cart, promotion
    cart_items = cart.items.select { |item| !item.is_suggested_product? }
    promotion.param.to_i - cart_items.size % promotion.param.to_i
  end

  def free_item_promotion_is_active?
    #promotion_free_item = Promotion.find_by_strategy("free_item_strategy")
    #promotion_free_item && promotion_free_item.active?
    false
  end

end
