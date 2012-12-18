module Promotions
  class FreeItemStrategy
    attr_reader :user, :promotion

    def initialize promotion, user
      @promotion = promotion
      @user = user
    end

    def matches?(cart)
      cart.items.count >= promotion.param.to_i if cart
    end

    def calculate_value(cart_items, item)
      number_of_items = cart_items.count / promotion.param.to_i
      free_items = sort_cart_items(cart_items).first(number_of_items)
      free_items.include?(item) ? 0 : item.price
    end

    def sort_cart_items(cart_items)
      cart_items.sort { |a,b|
        if a.price < b.price
          -1
        elsif a.price > b.price
          1
        else
          a.id > b.id ? -1 : 1
        end
      }
    end
  end
end
