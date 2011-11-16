# -*- encoding : utf-8 -*-
class FreightPrice < ActiveRecord::Base
  belongs_to :shipping_company
  
  ZIP_VALIDATION      = { :presence => true,
                          :numericality => { :only_integer => true , :greater_than_or_equal_to => 0, :less_than_or_equal_to => 99999999 }
                        }
  VALUE_VALIDATION    = { :presence => true,
                          :numericality => { :greater_than_or_equal_to => 0.0 }
                        }
  DELIVERY_VALIDATION = { :presence => true,
                          :numericality => { :only_integer => true, :greater_than_or_equal_to => 0 }
                        }

  validates :shipping_company, :presence => true
  validates :zip_start, ZIP_VALIDATION.clone
  validates :zip_end  , ZIP_VALIDATION.clone

  validates :weight_start , VALUE_VALIDATION.clone
  validates :weight_end   , VALUE_VALIDATION.clone

  validates :delivery_time, DELIVERY_VALIDATION.clone

  validates :price, VALUE_VALIDATION.clone
  validates :cost,  VALUE_VALIDATION.clone
end
