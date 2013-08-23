class Cep < ActiveRecord::Base
  attr_accessible :bairro, :cep, :cidade, :endereco, :estado, :nome_estado
end
