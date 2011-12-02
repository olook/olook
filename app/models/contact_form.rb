class ContactForm
  include ActiveModel::Validations

  attr_accessor :email, :subject, :message

  validates_presence_of :email, :subject, :message
  validates_format_of :email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i

  def initialize(attributes = {})
    attributes.each { |key, value| self.send("#{key}=", value) }
    @attributes = attributes
  end

  def read_attribute_for_validation(key)
    @attributes[key]
  end

  def to_key; end

  def save
    ContactMailer.send_contact_message(@email, @subject, @message).deliver if self.valid?
  end
end

