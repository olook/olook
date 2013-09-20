# -*- encoding : utf-8 -*-
class LandingPagesController < ApplicationController
  layout 'application'

  def show
    @landing_page = LandingPage.find_by_page_url!(params[:page_url])
    redirect_to root_path unless @landing_page.enabled?
  end

  def olookmovel
  	@campaign_email = CampaignEmail.new
  end

  def mother_day
  end

end
