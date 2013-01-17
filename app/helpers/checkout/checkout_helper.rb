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
    number_to_currency(FreightCalculator.freight_for_zip(address.zip_code, @cart_service.subtotal)[:price])
  end

end