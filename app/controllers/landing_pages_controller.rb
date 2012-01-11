# -*- encoding : utf-8 -*-
class LandingPagesController < ApplicationController

  def show
    @landing_page = LandingPage.find_by_page_url!(params[:page_url])
    redirect_to root_path unless @landing_page.enabled?
  end

end