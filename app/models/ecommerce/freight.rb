class Freight < ActiveRecord::Base
  belongs_to :order
  belongs_to :address
  belongs_to :shipping_service

  validates_presence_of :address_id
  validates_presence_of :shipping_service_id
  
  validates :price, :presence => true, :numericality => { :greater_than_or_equal_to => 0.0 }
  validates :cost, :presence => true, :numericality => { :greater_than_or_equal_to => 0.0 }
  validates :delivery_time, :presence => true, :numericality => { :only_integer => true, :greater_than_or_equal_to => 0 }

  before_create :set_address_fields

  private
  def set_address_fields
    self.country     = address.country
    self.city        = address.city
    self.state       = address.state
    self.complement  = address.complement
    self.street      = address.street
    self.number       = address.number
    self.neighborhood = address.neighborhood
    self.zip_code     = address.zip_code
    self.telephone    = address.telephone
  end
end
