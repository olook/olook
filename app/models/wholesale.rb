class Wholesale
  include ActiveModel::Validations
  attr_accessor :cnpj, :corporate_name, :fantasy_name, :first_name, :last_name, :email, :address, :neighborhood, :city, :state, :zip_code, :telephone, :cellphone, :telephone_company
  validates :first_name, :last_name, :email, :address, :neighborhood, :city, :state, :zip_code, :telephone, :cellphone, :telephone_company, presence: true
  validates :has_corporate, :inclusion => { :in => [true, false] }
  validates_presence_of :cnpj, :corporate_name, if: Proc.new { |wholesale| wholesale.has_corporate == true }
  validates_presence_of :fantasy_name, :corporate_name, if: Proc.new { |wholesale| wholesale.has_corporate == true }

end
