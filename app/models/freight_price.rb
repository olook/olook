# -*- encoding : utf-8 -*-
class FreightPrice < ActiveRecord::Base
  belongs_to :shipping_service

  scope :with_zip_and_value, ->(zip,value,shipping_ids) {where('(:zip >= zip_start) AND (:zip <= zip_end) AND (:order_value >= order_value_start) AND (:order_value <= order_value_end)', :zip => zip,:order_value => value).where(shipping_service_id: shipping_ids)}
  scope :free_cost, ->(zip,value,shipping_id) {where(':zip >= zip_start AND :zip <= zip_end AND :order_value < order_value_start', :zip => zip,:order_value => value).where(price: "0").where(shipping_service_id: shipping_id)}
  
  ZIP_VALIDATION      = { :presence => true,
                          :numericality => { :only_integer => true , :greater_than_or_equal_to => 0, :less_than_or_equal_to => 99999999 }
                        }
  VALUE_VALIDATION    = { :presence => true,
                          :numericality => { :greater_than_or_equal_to => 0.0 }
                        }
  DELIVERY_VALIDATION = { :presence => true,
                          :numericality => { :only_integer => true }
                        }

  validates :shipping_service, :presence => true
  validates :zip_start, ZIP_VALIDATION.clone
  validates :zip_end  , ZIP_VALIDATION.clone

  validates :order_value_start , VALUE_VALIDATION.clone
  validates :order_value_end   , VALUE_VALIDATION.clone

  validates :delivery_time, DELIVERY_VALIDATION.clone

  validates :price, VALUE_VALIDATION.clone
  validates :cost,  VALUE_VALIDATION.clone
end
