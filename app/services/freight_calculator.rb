# -*- encoding : utf-8 -*-
module FreightCalculator
  VALID_SHIPPING_SERVICES_ID_LIST = /^(\d+,?)*$/

  DEFAULT_FREIGHT_PRICE   = BigDecimal.new('0.0')
  DEFAULT_FREIGHT_COST    = BigDecimal.new('0.0')
  DEFAULT_INVENTORY_TIME  = 1
  DEFAULT_FREIGHT_SERVICE = 2 # CORREIOS

  DEFAULT_FREIGHT = {
    default_shipping: {
      price: DEFAULT_FREIGHT_PRICE,
      cost: DEFAULT_FREIGHT_COST,
      delivery_time: DEFAULT_INVENTORY_TIME + 4,
      shipping_service_id: DEFAULT_FREIGHT_SERVICE
    }
  }


  def self.freight_for_zip(zip_code, order_value, shipping_service_ids = nil, use_message = false)
    _zip_code = ZipCode::SanitizeService.clean(zip_code)
    return {} unless ZipCode::ValidService.apply?(_zip_code)
    freights = Shipping.with_zip(_zip_code)
    return DEFAULT_FREIGHT if freights.blank?
    TransportShippingChooserService.perform(freights)
  end

  private
    def self.shipping_services(shipping_service_ids)

      sanitized_list = sanitize(shipping_service_ids)
      if sanitized_list.any?
        ShippingService.where(id: sanitized_list)
      else
        ShippingService.order('priority')
      end
    end

    def self.sanitize list
      VALID_SHIPPING_SERVICES_ID_LIST =~ list ? list.split(",") : []
    end

end
