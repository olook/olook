
class WholesaleController < ApplicationController
	
  def new
	  @wholesale = Wholesale.new	
	end
  
  def create
  end
	
  private
   def custom_error_messages wholesale
     wholesale.errors.set(:cnpj, ["O CNPJ não está batendo. Pode conferir?"]) if (wholesale.errors.messages[:cnpj] && wholesale.errors.messages[:cnpj][0]) =~ /número inválido/
     wholesale.errors.set(:state, ["Precisamos da sigla do estado (UF)"]) if wholesale.errors.messages[:'addresses.state'].to_s[0]
     wholesale.errors.set(:address, ["Qual o nome da Rua, Avenida etc?"]) if wholesale.errors.messages[:'addresses.state'].to_s[0]
     wholesale.errors.set(:zip_code, ["Precisamos do seu CEP"]) if (wholesale.errors.messages[:'addresses.zip_code'] && wholesale.errors.messages[:'addresses.zip_code'][0] =~ /estranho/ )
   end
  
   def meta_description
     "Revenda na Olook as principais tendências da moda. Vantagens especiais e descontos progressivos. Seja uma de nossas afiliadas e ganhe com a gente."
    end
end
