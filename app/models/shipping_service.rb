# -*- encoding : utf-8 -*-
class ShippingService < ActiveRecord::Base
  DEFAULT_CUBIC_WEIGHT_FACTOR = 167

  has_many :freight_prices, :dependent => :destroy
  has_many :freights

  after_initialize :set_default_cubic_weight_factor

  validates :name, :presence => true
  validates :erp_code, :presence => true
  validates :cubic_weight_factor, :presence => true, :numericality => {:only_integer => true, :greater_than => 0}
  validates :priority, :presence => true, :numericality => {:only_integer => true, :greater_than => 0}
  validates :erp_delivery_service, :presence => true

  def find_freight_for_zip(zip_code, order_value)
    self.freight_prices.where('(:zip >= zip_start) AND (:zip <= zip_end) AND ' +
                              '(:order_value >= order_value_start) AND (:order_value <= order_value_end)',
                              :zip => zip_code.to_i,
                              :order_value => order_value).first
  end

  def freight_weight(weight, volume)
    cubic_weight = volume * cubic_weight_factor
    (weight > cubic_weight) ? weight : cubic_weight
  end

  def find_first_free_freight_for_zip_and_order(zip_code, order_value)
    self.freight_prices.where('(:zip >= zip_start) AND (:zip <= zip_end) AND ' +
                              '(:order_value < order_value_start) AND '+
                              '(price = 0)',
                              :zip => zip_code.to_i,
                              :order_value => order_value).first
  end

private

  def set_default_cubic_weight_factor
    self.cubic_weight_factor = DEFAULT_CUBIC_WEIGHT_FACTOR
  end
end
