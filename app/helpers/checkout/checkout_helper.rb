# -*- encoding : utf-8 -*-
module Checkout::CheckoutHelper

  MOTOBOY_FREIGHT_SERVICE_ID = 5
  SATURDAY = 6

  def errors_for(object, field, custom_class="span_error")
    if object
      errors = object.errors.messages[field].first if object.errors.messages[field]
      %(<span class="#{custom_class}">&nbsp;#{errors}</span>).html_safe if errors
    end
  end

  def show_motoboy_freight?
    is_motoboy_shipping = @shipping_service_fast.shipping_service_id == MOTOBOY_FREIGHT_SERVICE_ID
    Setting.superfast_shipping_enabled && is_motoboy_shipping && work_time?
  end

  def error_class_if_needed(object, field)
    return "" if object.nil?
    error_message = object.errors.messages[field]
    (error_message.nil? || error_message.empty?) ? "" : "input_error" if object
  end

  def freight_for(address)
    FreightCalculator.freight_for_zip(address.zip_code, @cart_service.subtotal)
  end

  def total_with_freight(value, payment_type=nil)
    @cart_service.total(payment: payment_type, freight_value: value)
  end

  def delivery_time_message(delivery_time)
    "(entrega em #{delivery_time} dias úteis)"
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
    number_to_currency(CartService.gift_wrap_price)
  end

  def show_freight_message
    return "O frete será de #{number_to_currency(@freight_price)}.<br />Adicionando um ítem<br/> de #{number_to_currency(@first_free_freight_price - @cart_service.total)} ele será <br/> gratuito. Aproveite ;)" unless @first_free_freight_price.blank?
    return "Seu frete será gratuito neste pedido :)" if @freight_price == 0
    return "O frete deste pedido será de #{number_to_currency(@freight_price)}."
  end

  def initial_freight shipping_service
    number_to_currency(shipping_service.try(:price) || "0")
  end

  def credit_discount_value
    discount_to_show = @cart_service.total_credits_discount > 0 ? -@cart_service.total_credits_discount : 0
    number_to_currency(discount_to_show)
  end

  private
    def work_time?
      current_time = Time.zone.now
      Time.workday?(current_time) && !Time.before_business_hours?(current_time) && !Time.after_business_hours?(current_time)
    end
end
