# -*- encoding : utf-8 -*-
class HomeController < ApplicationController

  def index
    @google_path_pixel_information = "Home"
    @chaordic_user = ChaordicInfo.user current_user

    @top5 = fetch_products :top5
    @stylist = fetch_products :selection

    if params[:share]
      @user = User.find(params[:uid])
      @profile = @user.profile_scores.first.try(:profile).try(:first_visit_banner)
      @qualities = Profile::DESCRIPTION["#{@profile}"]
      @url = request.protocol + request.host
    end
    incoming_params = params.clone.delete_if {|key| ['controller', 'action'].include?(key) }
    session[:tracking_params] ||= incoming_params
    if user_signed_in?
      redirect_to member_showroom_path(incoming_params)
      flash[:notice] = flash[:notice]
    end
  end


  private 
    def fetch_products label
      Product.where("id in (?)", Setting.send("home_#{label}").split(","))      
    end

end
