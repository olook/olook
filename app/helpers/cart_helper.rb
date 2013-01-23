# -*- encoding : utf-8 -*-
module CartHelper

  # TODO USER AND CART AS PARAMETER AND NOT AS INSTANCE VARIABLE, IT'S NOT MY FAULT
  def print_credit_message
    "(não podem ser utilizados em pedidos com desconto)" unless @cart_service.allow_credit_payment?
  end

  def total_user_credits
    return @user.current_credit if @cart_service.allow_credit_payment?
    @user.user_credits_for(:redeem).total
  end

  def promotion_discount(item)
    percent = calculate_percentage_for item
    number_to_percentage(percent, :precision => 0)
  end

  def remaining_items cart, promotion
    cart_items = cart.items.select { |item| !item.is_suggested_product? }
    promotion.param.to_i - cart_items.size % promotion.param.to_i
  end

  def free_item_promotion_is_active?
    false
  end

  def has_discount?(item)
    @cart_service.item_promotion?(item) || cart_has_percentage_coupon? || item.price != item.retail_price
  end

  private 
    def calculate_percentage_for item
      # for compatibility reason

      if cart_has_percentage_coupon? && @cart.total_coupon_discount > @cart.total_promotion_discount
        @cart.coupon.value
      else
        item_retail_price = @cart_service.item_retail_price(item)
        (item.price - item_retail_price) / item.price * BigDecimal("100.0")
      end
    end

    def cart_has_percentage_coupon?
      @cart.coupon && @cart.coupon.is_percentage?
    end

end
