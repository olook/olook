# -*- encoding : utf-8 -*-
module Checkout::CheckoutHelper

  def errors_for(object, field)
    if object
      errors = object.errors.messages[field].first if object.errors.messages[field]
      %(<span class="span_error">&nbsp;#{errors}</span>).html_safe if errors
    end
  end

  def error_class_if_needed(object, field)
    return "" if object.nil?
    error_message = object.errors.messages[field]
    (error_message.nil? || error_message.empty?) ? "" : "input_error" if object
  end

  def freight_for(address)
    FreightCalculator.freight_for_zip(address.zip_code, @cart_service.subtotal).first
  end

  def total_with_freight(freight_value, payment=nil)
    @cart_service.total(payment).to_f + freight_value.to_f
  end

  def billet_discount_enabled
    Setting.billet_discount_available
  end

  def billet_discount_percentage
    Setting.billet_discount_percent
  end

  def debit_discount_enabled
    Setting.debit_discount_available
  end

  def debit_discount_percentage
    Setting.debit_discount_percent
  end

  def gift_wrap_price(cart)
    cart.free_gift_wrap? ? "GRÁTIS" : number_to_currency(CartService.gift_wrap_price)
  end

  def show_freight_message
    return "O frete deste pedido será de #{number_to_currency(@freight_price)}.<br />Adicionando mais um ítem de #{number_to_currency(@first_free_freight_price - @cart_service.total())}<br/> em sua sacola seu frete será gratuito.<br /> Aproveite ;)" if @first_free_freight_price
    return "Seu frete será gratuito neste pedido :)" if @freight_price == 0
    return "O frete deste pedido será de #{number_to_currency(@freight_price)}."
  end

end
