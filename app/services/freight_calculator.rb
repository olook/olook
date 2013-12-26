# -*- encoding : utf-8 -*-
module FreightCalculator
  VALID_ZIP_FORMAT = /\A(\d{8})\z/
  VALID_SHIPPING_SERVICES_ID_LIST = /^(\d+,?)*$/


  DEFAULT_FREIGHT_PRICE   = 0.0
  DEFAULT_FREIGHT_COST    = 0.0
  DEFAULT_INVENTORY_TIME  = 10
  DEFAULT_FREIGHT_SERVICE = 2 # CORREIOS


  def self.freight_for_zip(zip_code, order_value, shipping_service_ids=nil, use_message = false)
    clean_zip_code = clean_zip(zip_code)
    return {} unless valid_zip?(clean_zip_code)
    return_array = []
    freight_prices = shipping_services(shipping_service_ids).map do |shipping_service|
      shipping_service.find_freight_for_zip(clean_zip_code, order_value)
    end
    return [{price: DEFAULT_FREIGHT_PRICE, cost: DEFAULT_FREIGHT_COST,delivery_time: DEFAULT_INVENTORY_TIME,shipping_service_id: DEFAULT_FREIGHT_SERVICE}] if freight_prices.empty?
    freight_prices.compact.each do |freight|
      return_array << {
      :price => freight.try(:price) || DEFAULT_FREIGHT_PRICE,
      :cost => freight.try(:cost) || DEFAULT_FREIGHT_COST,
      :delivery_time => (freight.try(:delivery_time) || 0) + DEFAULT_INVENTORY_TIME,
      :shipping_service_id => freight.try(:shipping_service_id) || DEFAULT_FREIGHT_SERVICE,
      :shipping_service_priority => freight.try(:shipping_service).try(:priority),
      :cost_for_free => (freight.price != 0.0) && use_message ? freight.shipping_service.find_first_free_freight_for_zip_and_order(clean_zip_code, order_value).try(:order_value_start) : ''
    }
    end
    TransportShippingService.new(return_array).choose_better_transport_shipping
  end

  def self.valid_zip?(zip_code)
    zip_code.match(VALID_ZIP_FORMAT) ? true : false
  end

  def self.clean_zip(dirty_zip)
    return dirty_zip.gsub(/\D/, '')
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
