# -*- encoding : utf-8 -*-
class ShippingCompany < ActiveRecord::Base
  has_many :freight_prices, :dependent => :destroy

  validates :name, :presence => true
  
  def find_freight_for_zip(zip_code, weight, volume)
    self.freight_prices.where('(:zip >= zip_start) AND (:zip <= zip_end) AND ' +
                              '(:weight > weight_start) AND (:weight <= weight_end)',
                              :zip => zip_code.to_i,
                              :weight => freight_weight(weight, volume)).first
  end

  def freight_weight(weight, volume)
    cubic_weight = volume * cubic_weight_factor
    (weight > cubic_weight) ? weight : cubic_weight
  end
  
  def cubic_weight_factor
    167 # default value for a while
  end
end
