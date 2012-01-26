# -*- encoding : utf-8 -*-
class HomeController < ApplicationController
  before_filter :redirect_logged_user, :save_tracking_params, :only => :index

  def index
    if params[:share]
      @user = User.find(params[:uid])
      @profile = @user.profile_scores.first.try(:profile).first_visit_banner
      @qualities = Profile::DESCRIPTION["#{@profile}"]
      @url = request.protocol + request.host 
    end
  end

private

  def redirect_logged_user
    redirect_to(member_showroom_path) if user_signed_in?
  end
  
  def save_tracking_params
    incoming_params = params.clone.delete_if {|key| ['controller', 'action'].include?(key) }

    if !incoming_params.empty?
      session[:tracking_params] = incoming_params
    end
  end
end
