class Reseller < User
  attr_accessible :cnpj, :active, :reseller, :corporate_name, :has_corporate
  attr_accessor :cnpj, :active, :reseller, :corporate_name, :has_corporate
  scope :all_reseller, where(reseller: true)
end
