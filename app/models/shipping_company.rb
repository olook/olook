# -*- encoding : utf-8 -*-
class ShippingCompany < ActiveRecord::Base
  has_many :freight_prices, :dependent => :destroy

  validates :name, :presence => true
end
