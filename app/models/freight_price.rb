# -*- encoding : utf-8 -*-
class FreightPrice < ActiveRecord::Base
  belongs_to :shipping_company

  validates :zip_start, :presence => true
  validates :zip_end, :presence => true
  validates :weight_start, :presence => true
  validates :weight_end, :presence => true
  validates :delivery_time, :presence => true
  validates :price, :presence => true
  validates :cost, :presence => true
end
