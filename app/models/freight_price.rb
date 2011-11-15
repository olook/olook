# -*- encoding : utf-8 -*-
class FreightPrice < ActiveRecord::Base
  belongs_to :shipping_company

  validates :shipping_company, :presence => true
  validates :zip_start, :presence => true,
                        :numericality => { :only_integer => true , :greater_than_or_equal_to => 0, :less_than_or_equal_to => 99999999 }
  validates :zip_end  , :presence => true,
                        :numericality => { :only_integer => true , :greater_than_or_equal_to => 0, :less_than_or_equal_to => 99999999 }

  validates :weight_start,  :presence => true,
                            :numericality => { :greater_than_or_equal_to => 0.0 }
  validates :weight_end,    :presence => true,
                            :numericality => { :greater_than_or_equal_to => 0.0 }

  validates :delivery_time, :presence => true,
                            :numericality => { :only_integer => true, :greater_than_or_equal_to => 0 }

  validates :price, :presence => true,
                    :numericality => { :greater_than_or_equal_to => 0.0 }
  validates :cost,  :presence => true,
                    :numericality => { :greater_than_or_equal_to => 0.0 }
end
