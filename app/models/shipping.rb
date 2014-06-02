class Shipping < ActiveRecord::Base
  attr_accessible :carrier, :cost, :delivery_time, :income, :zip_end, :zip_start
  scope :with_zip, ->(zip) {where('(:zip >= zip_start) AND (:zip <= zip_end)', zip: zip)}
  scope :with_shipping_service, ->(id) {where(shipping_service_id: id)}
end
