class ShippingPolicy < ActiveRecord::Base
  attr_accessible :value_end, :value_start, :zip_end, :zip_start
end
