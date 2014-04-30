class Shipping < ActiveRecord::Base
  attr_accessible :carrier, :cost, :delivery_time, :income, :zip_end, :zip_start
end
