# == Schema Information
#
# Table name: freight_prices
#
#  id                  :integer          not null, primary key
#  shipping_service_id :integer
#  zip_start           :integer
#  zip_end             :integer
#  order_value_start   :decimal(8, 3)
#  order_value_end     :decimal(8, 3)
#  delivery_time       :integer
#  price               :decimal(8, 2)
#  cost                :decimal(8, 2)
#  description         :string(255)
#  created_at          :datetime
#  updated_at          :datetime
#

# -*- encoding : utf-8 -*-
class FreightPrice < ActiveRecord::Base
  belongs_to :shipping_service
  
  ZIP_VALIDATION      = { :presence => true,
                          :numericality => { :only_integer => true , :greater_than_or_equal_to => 0, :less_than_or_equal_to => 99999999 }
                        }
  VALUE_VALIDATION    = { :presence => true,
                          :numericality => { :greater_than_or_equal_to => 0.0 }
                        }
  DELIVERY_VALIDATION = { :presence => true,
                          :numericality => { :only_integer => true, :greater_than_or_equal_to => 0 }
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
