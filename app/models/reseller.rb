class Reseller < User
  attr_accessible :cnpj, :active, :reseller, :corporate_name
  attr_accessor :cnpj, :active, :reseller, :corporate_name
  scope :all_reseller, where(reseller: true)
end
