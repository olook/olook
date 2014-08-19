class Wholesale
  include ActiveModel::Validations
  attr_accessor :cnpj, :corporate_name, :fantasy_name, :first_name, :last_name, :email, :address, :neighborhood, :city, :state, :zip_code, :telephone, :cellphone, :telephone_company
  validates_presence_of :first_name
  
end
