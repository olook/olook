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
      items.count >= promotion.param.to_i if cart
    end

    def calculate_value(cart_items, item)
      items = items_for_discount(cart_items)
      number_of_items = items.count / promotion.param.to_i
      free_items = sort_cart_items(items).first(number_of_items)
      free_items.include?(item) ? 0 : item.price
    end

    private

    def sort_cart_items(cart_items)
      cart_items.sort { |a,b|
        if a.price < b.price
          FIRST_ITEM
        elsif a.price > b.price
          SECOND_ITEM
        else
          a.id > b.id ? FIRST_ITEM : SECOND_ITEM
        end
      }
    end

    def items_for_discount(cart_items)
      cart_items.map { |item| item.product.can_supports_discount? ? item : nil }.compact
    end
  end
end
