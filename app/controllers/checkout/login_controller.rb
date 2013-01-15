class Checkout::LoginController < ApplicationController

  before_filter :check_user_logged
  
  def index
  end

  def new
    data = session["devise.facebook_data"]["extra"]["raw_info"] if session["devise.facebook_data"]
    data ||= []
    @resource_user = User.new({
      first_name: data["first_name"],
      last_name: data["last_name"],
      email: data["email"]
      })
  end

  private

  def check_user_logged
    redirect_to checkout_cart_path if logged_in?
  end

end