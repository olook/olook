class Wholesale
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming
  attr_accessor :cnpj, :corporate_name, :fantasy_name, :first_name, :last_name, :email, :address, :neighborhood, :city, :state, :zip_code, :telephone, :cellphone, :cellphone_company
  validates_presence_of :cnpj, :corporate_name, :fantasy_name, :first_name, :last_name, :email, :address, :neighborhood, :city, :state, :zip_code, :telephone

  def initialize(attributes = {})
      attributes.each do |name, value|
        send("#{name}=", value)
      end
  end


  def persisted?
  	false
  end

end
