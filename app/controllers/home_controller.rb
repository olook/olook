# -*- encoding : utf-8 -*-
class HomeController < ApplicationController
  layout 'lite_application'

  def index
    @google_path_pixel_information = "Home"
    @chaordic_user = ChaordicInfo.user(current_user,cookies[:ceid])
    @looks = RecomendationService.new(profiles: current_user.try(:profiles)).full_looks(limit: 4)
    prepare_for_home
  end

end
