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
    result = Freight::TransportShippingChooserService.new(freights).perform
    check_free_freight_policy(result, _zip_code, order_value)
  end

   private
   def self.check_free_freight_policy(result, zip_code, order_value)
     if Freight::FreeCostPolicy.apply?( ShippingPolicy.with_zip(zip_code), order_value)
       result[:default_shipping][:cost] = '0.0'.to_d
     end
     result
   end
end
