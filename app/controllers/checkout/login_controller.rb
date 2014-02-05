class Checkout::LoginController < ApplicationController

  layout "checkout"

  before_filter :check_user_logged
  
  def index
    session[:facebook_redirect_paths] = "checkout"
  end

  private

  def check_user_logged
    redirect_to new_checkout_url(protocol: 'https') if logged_in?
  end

end
