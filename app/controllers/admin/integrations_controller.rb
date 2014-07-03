class Admin::IntegrationsController < Admin::BaseController
  authorize_resource :class => false
  
  def index
  	@kanui = KanuiIntegration.new
  end

  def update
  	product_ids = params[:product_ids].split(",")
    active = params[:active] == "1"

  	kanui_integration = KanuiIntegration.new(list: product_ids, active: active)
    kanui_integration.send_products_email if active
    
    redirect_to admin_integrations_path
  end
end
