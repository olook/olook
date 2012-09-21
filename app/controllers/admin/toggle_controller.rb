# -*- encoding : utf-8 -*-
class Admin::ToggleController < Admin::BaseController
  def switch_mode
    session[:product_view_mode] = session[:product_view_mode] == "admin" || session[:product_view_mode].nil? ? "user" : "admin"
    redirect_to :back
  end
end
