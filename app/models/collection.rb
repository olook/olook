# -*- encoding : utf-8 -*-
class Collection < ActiveRecord::Base
  has_many :products
  
  validates :start_date, :presence => true
  validates :end_date, :presence => true
end
