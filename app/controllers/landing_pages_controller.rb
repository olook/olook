# -*- encoding : utf-8 -*-
class LandingPagesController < ApplicationController
  def show
    @landing_page = LandingPage.find_by_page_url(params[:page_url])
  end
end