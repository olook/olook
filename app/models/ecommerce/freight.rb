class Freight < ActiveRecord::Base
  belongs_to :order
  belongs_to :address
  belongs_to :shipping_service

  validates_presence_of :address_id
  validates_presence_of :shipping_service_id
  
  validates :price, :presence => true, :numericality => { :greater_than_or_equal_to => 0.0 }
  validates :cost, :presence => true, :numericality => { :greater_than_or_equal_to => 0.0 }
  validates :delivery_time, :presence => true, :numericality => { :only_integer => true, :greater_than_or_equal_to => 0 }

  delegate :city, :to => :address, :prefix => false, :allow_nil => true
  delegate :state, :to => :address, :prefix => false, :allow_nil => true

end
