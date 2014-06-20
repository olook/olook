# -*- encoding : utf-8 -*-
class OlookProductsTotalValue < PromotionRule
  OLOOK_BRANDS = ["olook", "olook essential", "olook concept"]

  def name
    'A Somatória do preço de venda dos produtos Olook for maior que...'
  end

  def need_param
    true
  end

  def matches?(cart, parameter)
    return false unless cart
    olook_products_total_value(cart) >= BigDecimal(parameter)
  end

  private
    def olook_products(cart) 
      cart.items.select{|item| OLOOK_BRANDS.include?(item.variant.product.brand.downcase)}
    end

    def olook_products_total_value(cart)
      olook_products(cart).inject(0) { |total, item| total += item.retail_price * item.quantity }
    end
end
