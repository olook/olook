# -*- encoding : utf-8 -*-
module FreightCalculator
  VALID_ZIP_FORMAT = /\A(\d{8})\z/
  
  DEFAULT_FREIGHT_PRICE   = 0.0
  DEFAULT_FREIGHT_COST    = 0.0
  DEFAULT_INVENTORY_TIME  = 1
  
  def self.freight_for_zip(zip_code, weight, volume)
    clean_zip_code = clean_zip(zip_code)
    return {} unless valid_zip?(clean_zip_code)

    freight_price = nil
    ShippingService.order('priority').each do |shipping_service|
      freight_price = shipping_service.find_freight_for_zip(clean_zip_code, weight, volume)

      break if freight_price
    end
      
    { :price          => freight_price.try(:price)  || DEFAULT_FREIGHT_PRICE,
      :cost           => freight_price.try(:cost)   || DEFAULT_FREIGHT_COST,
      :delivery_time  => (freight_price.try(:delivery_time) || 0) + DEFAULT_INVENTORY_TIME }
  end
  
  def self.valid_zip?(zip_code)
    zip_code.match(VALID_ZIP_FORMAT) ? true : false
  end
  
  def self.clean_zip(dirty_zip)
    return dirty_zip.gsub /\D/, '' 
  end
end
