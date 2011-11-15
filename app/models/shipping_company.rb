# -*- encoding : utf-8 -*-
class ShippingCompany < ActiveRecord::Base
  has_many :freight_prices, :dependent => :destroy

  validates :name, :presence => true
  
  def find_freight_for_zip(zip_code)
    self.freight_prices.where('(:zip >= zip_start) AND (:zip <= zip_end)',
                              :zip => zip_code.to_i).first
  end
end
