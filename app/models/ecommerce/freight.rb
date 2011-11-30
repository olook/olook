class Freight < ActiveRecord::Base
  belongs_to :order
  belongs_to :address
  validates_presence_of :address_id
  validates :price, :presence => true, :numericality => { :greater_than_or_equal_to => 0.0 }
  validates :cost, :presence => true, :numericality => { :greater_than_or_equal_to => 0.0 }
  validates :delivery_time, :presence => true, :numericality => { :only_integer => true, :greater_than_or_equal_to => 0 }
end
