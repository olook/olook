class ShippingPolicy < ActiveRecord::Base
  attr_accessible :value_end, :value_start, :zip_end, :zip_start
  scope :with_zip, ->(zip) {where('(:zip >= zip_start) AND (:zip <= zip_end)', zip: zip)}
end
