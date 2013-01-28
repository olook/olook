# -*- encoding : utf-8 -*-
module Checkout::CheckoutHelper

  def errors_for(object, field)
    if object
      errors = object.errors.messages[field].first
      %(<span class="span_error">&nbsp;#{errors}</span>).html_safe if errors
    end
  end

  def error_class_if_needed(object, field)
    object.errors.messages[field].empty? ? "" : "input_error" if object
  end

  def freight_for(address)
    FreightCalculator.freight_for_zip(address.zip_code, @cart_service.subtotal)
  end

  def total_with_freight(freight_value)
    @cart_service.total + freight_value
  end

  def delivery_time_message(delivery_time)
    "(entrega em #{delivery_time} dias úteis)"
  end

  def billet_discount_enabled
    Setting.billet_discount_available
  end

end