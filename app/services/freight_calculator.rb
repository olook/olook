# -*- encoding : utf-8 -*-
require 'bigdecimal'
module FreightCalculator
  VALID_SHIPPING_SERVICES_ID_LIST = /^(\d+,?)*$/

  DEFAULT_FREIGHT_PRICE   = BigDecimal.new('0.0')
  DEFAULT_FREIGHT_COST    = BigDecimal.new('0.0')
  DEFAULT_INVENTORY_TIME  = 2
  DEFAULT_INVENTORY_TIME_WITH_EXTRA_TIME = DEFAULT_INVENTORY_TIME + 4
  DEFAULT_FREE_SHIPPING_VALUE = BigDecimal.new('150.0')

  DEFAULT_FREIGHT_SERVICE = 2 # CORREIOS


  DEFAULT_FREIGHT = {
    default_shipping: {
      price: DEFAULT_FREIGHT_PRICE,
      cost: DEFAULT_FREIGHT_COST,
      delivery_time: DEFAULT_INVENTORY_TIME_WITH_EXTRA_TIME,
      shipping_service_id: DEFAULT_FREIGHT_SERVICE,
      free_shipping_value: DEFAULT_FREE_SHIPPING_VALUE
    }
  }

  def self.freight_for_zip(zip_code, order_value, shipping_service_ids = nil, opts={})
    _zip_code = ZipCode::SanitizeService.clean(zip_code)
    return {} unless ZipCode::ValidService.apply?(_zip_code)
    freights = prepare_shipping_query(_zip_code)
    selected_freight = freights.find { |s| s.shipping_service_id.to_s == shipping_service_ids.to_s }
    return DEFAULT_FREIGHT if freights.blank?
    result = prepare_shipping_for(freights, _zip_code, order_value)

    if selected_freight
      selected_result = result.values.find { |v| v[:shipping_service_id] == selected_freight.shipping_service_id } || result[:default_shipping]
      result = {default_shipping: selected_result}
    end
    result
  end

  private
  def self.check_free_freight_policy(result, zip_code_policies, order_value)
    if Freight::FreeCostPolicy.apply?( zip_code_policies, order_value)
      result[:default_shipping][:price] = '0.0'.to_d
    end
    result
  end

  def self.prepare_shipping_query(zip_code, shipping_ids=nil)
    shipping_query = Shipping.with_zip(zip_code)
    shipping_query = shipping_query.with_shipping_service(shipping_ids) if shipping_ids
    shipping_query
  end

  def self.find_policies_for_zip zip_code
    ShippingPolicy.with_zip(zip_code)
  end

  def self.prepare_shipping_for(freights, zip_code, order_value)
    zip_code_policies = find_policies_for_zip(zip_code)
    result = FreightService::TransportShippingChooserService.new(freights, zip_code_policies).perform
    check_free_freight_policy(result, zip_code_policies, order_value)
  end
end
