# -*- encoding : utf-8 -*-
class LandingPagesController < ApplicationController

  def show
    @landing_page = LandingPage.find_by_page_url!(params[:page_url])
    redirect_to root_path unless @landing_page.enabled?
  end

  private

  def not_found
    render :file => "#{Rails.root}/public/404.html", :status => :not_found
  end
end