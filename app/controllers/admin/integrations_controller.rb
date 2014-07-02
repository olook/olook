class Admin::IntegrationsController < Admin::BaseController
  authorize_resource :class => false
  
  def index
  	@kanui = KanuiIntegration.new
  end

  def update
  	product_ids = params[:product_ids].split(",")
    active = params[:active] == "1"

  	kanui_integration = KanuiIntegration.new(list: product_ids, active: active)
    if params[:send_email] == "1"
      kanui_integration.send_products_email
    end
    
    redirect_to admin_integrations_path
  end
end
