# -*- encoding : utf-8 -*-
class WholesaleController < ApplicationController
	def new
	  @wholesale = Wholesale.new	
	end

	def create
      @wholesale = Wholesale.new(params[:wholesale])
      if @reseller.save
      sign_in(:user, @reseller)
      SACAlertMailer.wholesale_notification(@wholesale, "lucas.santana@olook.com.br" ).deliver
      
    else
      custom_error_messages @wholesale
      render "new"
    end
    end


    private
   def custom_error_messages wholesale
     wholesale.errors.set(:cnpj, ["O CNPJ não está batendo. Pode conferir?"]) if (wholesale.errors.messages[:cnpj] && wholesale.errors.messages[:cnpj][0]) =~ /número inválido/
     wholesale.errors.set(:'addresses.state', ["Precisamos da sigla do estado (UF)"]) if wholesale.errors.messages[:'addresses.state'].to_s[0]
     wholesale.errors.set(:'addresses.street', ["Qual o nome da Rua, Avenida etc?"]) if wholesale.errors.messages[:'addresses.state'].to_s[0]
     wholesale.errors.set(:'addresses.zip_code', ["Precisamos do seu CEP"]) if (wholesale.errors.messages[:'addresses.zip_code'] && wholesale.errors.messages[:'addresses.zip_code'][0] =~ /estranho/ )
   end

end
