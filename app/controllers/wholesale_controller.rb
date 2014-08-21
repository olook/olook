
class WholesaleController < ApplicationController
	
  def new
	  @wholesale = Wholesale.new	
	end
  
  def create
    @wholesale = Wholesale.new(params[:wholesale_form])
    if @wholesale.valid?
      SACAlertMailer.wholesale_notification(@wholesale).deliver
      redirect_to wholesale_show_path
    else
      render action: 'new' 
    end
  end

  def show
  end
	
  
   def meta_description
     "Revenda na Olook as principais tendências da moda. Vantagens especiais e descontos progressivos. Seja uma de nossas afiliadas e ganhe com a gente."
    end
end
