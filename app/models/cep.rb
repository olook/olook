class Cep < ActiveRecord::Base
  attr_accessible :bairro, :cep, :cidade, :endereco, :estado, :nome_estado

  def adapt_cep_to_address_hash
    {zip_code: self.cep.insert(5, '-'), street: self.endereco, neighborhood: self.bairro, city: self.cidade, state: self.estado}
  end
end
