module Promotions
  class PurchasesAmountStrategy
    attr_reader :user, :promotion

    def initialize promotion, user, order=nil
      @promotion = promotion
      @user = user
      @order = order
    end

    def matches?(cart)
      return false unless user && user.created_at
      return false if DiscountExpirationCheckService.discount_expired?(user)

      user ? user.orders.purchased.size == promotion.param.to_i : 0 == promotion.param.to_i
    end

    def calculate_value(cart_items, item)
      item.price - ((item.price * promotion.discount_percent) / 100)
    end

    def calculate_promotion_discount(cart_items)
      total_promotion_discount = get_total_retail_price_without_discounts(cart_items) * @promotion.discount_percent / 100
      {value: total_promotion_discount, percent: @promotion.discount_percent}
    end

    def matches_20_percent_promotion?
      matches?(nil) && order_have_promotion_id?
    end

    private
    def order_have_promotion_id?(id=1)
      @order.payments.map(&:promotion_id).include?(id) if !@order.payments.empty?
    end

    def get_total_retail_price_without_discounts(cart_items)
      cart_items.inject(0) do |sum, item|
        sum += (item.variant.product.retail_price * item.quantity)
      end
    end

  end
end
