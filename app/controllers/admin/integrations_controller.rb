class Admin::IntegrationsController < Admin::BaseController
  authorize_resource :class => false
  
  def index
  	@kanui = KanuiIntegration.new
  end

  def update
  	product_ids = params[:product_ids].split(",")
    active = params[:active] == "1"

  	KanuiIntegration.new(list: product_ids, active: active)
    
    redirect_to admin_integrations_path
  end
end
