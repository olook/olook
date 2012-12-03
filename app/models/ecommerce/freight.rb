# == Schema Information
#
# Table name: freights
#
#  id                  :integer          not null, primary key
#  price               :decimal(8, 2)
#  cost                :decimal(8, 2)
#  delivery_time       :integer
#  order_id            :integer
#  address_id          :integer
#  shipping_service_id :integer          default(1)
#  tracking_code       :string(255)
#  country             :string(255)
#  city                :string(255)
#  state               :string(255)
#  complement          :string(255)
#  street              :string(255)
#  number              :string(255)
#  neighborhood        :string(255)
#  zip_code            :string(255)
#  telephone           :string(255)
#  mobile              :string(255)
#

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
    self.country      = address.country
    self.city         = address.city
    self.state        = address.state
    self.complement   = address.complement
    self.street       = address.street
    self.number       = address.number
    self.neighborhood = address.neighborhood
    self.zip_code     = address.zip_code
    self.telephone    = address.telephone
    self.mobile       = address.mobile
  end
end
