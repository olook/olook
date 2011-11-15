# -*- encoding : utf-8 -*-
module FreightCalculator
  VALID_ZIP_FORMAT = /\A(\d{8})\z/
  
  def self.freight_for_zip(zip_code)
    clean_zip_code = clean_zip(zip_code)
    return {} unless valid_zip?(clean_zip_code)

    freight_price = nil
    ShippingCompany.all.each do |shipping_company|
      freight_price = shipping_company.find_freight_for_zip(clean_zip_code)

      break if freight_price
    end
      
    { :price          => freight_price.try(:price)  || 0.0,
      :cost           => freight_price.try(:cost)   || 0.0,
      :delivery_time  => freight_price.try(:delivery_time) || 0 }
  end
  
  def self.valid_zip?(zip_code)
    zip_code.match(VALID_ZIP_FORMAT) ? true : false
  end
  
  def self.clean_zip(dirty_zip)
    return dirty_zip.gsub /\D/, '' 
  end
end
