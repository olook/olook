class Address < ActiveRecord::Base
  belongs_to :user
  has_many :freights
  before_save :fill_phone_numbers

  STATES = ["AC", "AL", "AP", "AM", "BA", "CE", "DF", "ES", "GO", "MA", "MT", "MS", "MG", "PA", "PB", "PR", "PE", "PI", "RJ", "RN", "RS", "RO", "RR", "SC", "SP", "SE", "TO"]

  ZipCodeFormat = /^[0-9]{5}-[0-9]{3}$/
  PhoneFormat = /^(?:\(11\)9\d{4}-\d{3,4}|\(\d{2}\)\d{4}-\d{4})$/
  MobileFormat = /^(?:\(11\)9\d{4}-\d{3,4}|\(\d{2}\)\d{4}-\d{4})$/
  StateFormat = /^[A-Z]{2}$/

  validates_presence_of :country, :state, :street, :city, :number, :zip_code, :neighborhood

  validates :mobile, :presence => true, :unless => :telephone?
  validates :telephone, :presence => true, :unless => :mobile?

  validates :number, :numericality => true, :presence => true
  validates :zip_code, :format => {:with => ZipCodeFormat}
  validates :telephone, :format => {:with => PhoneFormat}, :if => :telephone?
  validates :mobile, :format => { :with => MobileFormat }, :if => :mobile?
  validates :state, :format => {:with => StateFormat}

  def identification
    "#{first_name} #{last_name}"
  end

  # private
  def fill_phone_numbers
    self.telephone = mobile.gsub('(11)9','(11)') if telephone.blank? and mobile =~ /^(?:\(11\)9\d{4}-\d{4})$/
  end

end
