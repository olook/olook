# -*- encoding : utf-8 -*-
class ShippingCompany < ActiveRecord::Base
  validates :name, :presence => true
end
