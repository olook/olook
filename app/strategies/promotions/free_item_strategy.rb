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

    private

    def sort_cart_items(cart_items)
      cart_items.sort_by { |item| [item.price, item.id]}
    end

    def items_for_discount(cart_items)
      cart_items.map { |item| item.product.can_supports_discount? ? item : nil }.compact
    end
  end
end
