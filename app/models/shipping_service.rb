# -*- encoding : utf-8 -*-
class ShippingService < ActiveRecord::Base

  has_many :freight_prices, :dependent => :destroy
  has_many :freights
  has_many :shippings, :dependent => :destroy

  validates :name, :presence => true
  validates :erp_code, :presence => true

  def find_freight_for_zip(zip_code, order_value)
    self.freight_prices.where('(:zip >= zip_start) AND (:zip <= zip_end) AND ' +
                              '(:order_value >= order_value_start) AND (:order_value <= order_value_end)',
                              :zip => zip_code.to_i,
                              :order_value => order_value).first
  end

  def find_first_free_freight_for_zip_and_order(zip_code, order_value)
    self.freight_prices.where('(:zip >= zip_start) AND (:zip <= zip_end) AND ' +
                              '(:order_value < order_value_start) AND '+
                              '(price = 0)',
                              :zip => zip_code.to_i,
                              :order_value => order_value).first
  end

private

  after_initialize do
    self.erp_code = self.name
  end
end
