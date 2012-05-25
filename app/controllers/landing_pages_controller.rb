# -*- encoding : utf-8 -*-
class LandingPagesController < ApplicationController
  layout "application"

  def show
    @landing_page = LandingPage.find_by_page_url!(params[:page_url])
    incoming_params = params.clone.delete_if {|key| ['controller', 'action'].include?(key) }
    session[:tracking_params] ||= incoming_params
    redirect_to root_path unless @landing_page.enabled?
  end

end