module Promotions
  class FreeItemStrategy
    FIRST_ITEM = -1
    SECOND_ITEM = 1
    attr_reader :user, :promotion

    def initialize promotion, user
      @promotion = promotion
      @user = user
    end

    def matches?(cart)
      items = items_for_discount(cart.items)
      items.size >= promotion.param.to_i if cart
    end

    def calculate_value(cart_items, item)
      items = items_for_discount(cart_items)
      number_of_items = items.size / promotion.param.to_i
      free_items = sort_cart_items(items).first(number_of_items)
      free_items.include?(item) ? 0 : item.price
    end

    def calculate_promotion_discount(cart_items)
      total_retail_price_without_discount = get_total_retail_price_without_discounts(cart_items)
      total_retail_price_with_discount = get_total_retail_price_with_discounts(cart_items)
      total_promotion_discount = total_retail_price_without_discount - total_retail_price_with_discount
      total_promotion_discount_percent = (1 - (total_retail_price_with_discount / total_retail_price_without_discount)) * 100
      {value: total_promotion_discount, percent: total_promotion_discount_percent}
    end

    private

    def sort_cart_items(cart_items)
      cart_items.sort_by { |item| [item.price, item.id]}
    end

    def items_for_discount(cart_items)
      cart_items.map { |item| item.product.can_supports_discount? ? item : nil }.compact
    end

    def get_total_retail_price_without_discounts(cart_items)
      cart_items.inject(0) do |sum, item|
        sum += (item.variant.product.retail_price * item.quantity)
      end
    end

    def get_total_retail_price_with_discounts(cart_items)
      cart_items.inject(0) do |sum, item|
        sum += calculate_value(cart_items, item)
      end
    end

  end
end
