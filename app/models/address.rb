class Address < ActiveRecord::Base
  belongs_to :user

  ZipCodeFormat = /^[0-9]{5}-[0-9]{3}$/
  PhoneFormat = /^\([0-9]{2}\)[0-9]{4}-[0-9]{4}$/
  StateFormat = /^[A-Z]{2}$/

  validates_presence_of :country, :state, :street, :number, :zip_code, :neighborhood, :telephone
  validates :number, :numericality => true, :presence => true
  validates :zip_code, :format => {:with => ZipCodeFormat}
  validates :telephone, :format => {:with => PhoneFormat}
  validates :state, :format => {:with => StateFormat}
end
