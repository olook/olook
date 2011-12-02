# -*- encoding : utf-8 -*-
class Collection < ActiveRecord::Base
  has_many :products
  
  validates :start_date, :presence => true
  validates :end_date, :presence => true
  
  def self.for_date(date)
    Collection.where( '(:date >= start_date) AND (:date <= end_date)',
                      :date => date).first
  end
  
  def self.current
    self.for_date(Date.today)
  end
end
