# -*- encoding : utf-8 -*-
class HomeController < ApplicationController

  def index
    incoming_params = params.clone.delete_if {|key| ['controller', 'action'].include?(key) }
    session[:tracking_params] ||= incoming_params
    redirect_to member_showroom_path(incoming_params) if user_signed_in?
  end

end
