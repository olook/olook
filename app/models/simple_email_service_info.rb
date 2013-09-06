class SimpleEmailServiceInfo < ActiveRecord::Base
  attr_accessible :bounces, :complaints, :delivery_attempts, :rejects
end
