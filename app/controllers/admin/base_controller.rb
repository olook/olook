class Admin::BaseController < ActionController::Base
  protect_from_forgery
  before_filter :authenticate_admin!

  layout "admin"

  rescue_from CanCan::AccessDenied do  |exception|
    flash[:error] = "Access Denied! You don't have permission to execute this action.
    Contact the system administrator"
    redirect_to admin_url
  end

  def render_public_exception
    case env["action_dispatch.exception"]
      when ActiveRecord::RecordNotFound, ActionController::UnknownController,
        ::AbstractController::ActionNotFound
        render :template => "/errors/404.html.erb", :layout => 'error', :status => 404
      else
        render :template => "/errors/500.html.erb", :layout => 'error', :status => 500
    end
  end

  private

  def current_ability
    @current_ability ||= ::Ability.new(current_admin)
  end
end
