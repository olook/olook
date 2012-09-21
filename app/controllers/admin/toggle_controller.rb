# -*- encoding : utf-8 -*-
class Admin::ToggleController < Admin::BaseController
  def switch_mode
    session[:temp_user] = session[:temp_user] == "admin" || session[:temp_user].nil? ? "user" : "admin"
    redirect_to :back
  end
end
