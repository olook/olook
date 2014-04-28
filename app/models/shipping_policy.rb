class ShippingPolicy < ActiveRecord::Base
  attr_accessible :value_end, :value_start, :zip_end, :zip_start
  scope :zip_code_between, ->(zip) {where('(:zip >= zip_start) AND (:zip <= zip_end)', zip: zip)}
end
