# -*- encoding : utf-8 -*-
class HomeController < ApplicationController

  def index
    @google_path_pixel_information = "Home"
    @chaordic_user = ChaordicInfo.user current_user

    prepare_for_home
    if user_signed_in?
      redirect_to member_showroom_path(@incoming_params)
      flash[:notice] = flash[:notice]
    end
  end

end
