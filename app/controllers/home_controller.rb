# -*- encoding : utf-8 -*-
class HomeController < ApplicationController

  def index
    if params[:share]
      @user = User.find(params[:uid])
      @profile = @user.profile_scores.first.try(:profile).first_visit_banner
      @qualities = Profile::DESCRIPTION["#{@profile}"]
      @url = request.protocol + request.host 
    end
    incoming_params = params.clone.delete_if {|key| ['controller', 'action'].include?(key) }
    session[:tracking_params] ||= incoming_params
    redirect_to member_showroom_path(incoming_params) if user_signed_in?
  end

end