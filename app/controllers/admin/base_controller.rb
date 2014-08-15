class Admin::BaseController < ActionController::Base
  protect_from_forgery
  before_filter :authenticate_admin!

  layout "admin"

  rescue_from CanCan::AccessDenied do  |exception|
    flash[:error] = "Access Denied! You don't have permission to execute this action.
    Contact the system administrator"
    redirect_to admin_url
  end

  private

  def current_ability
    @current_ability ||= ::Ability.new(current_admin)
  end
end
