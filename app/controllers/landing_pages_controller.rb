# -*- encoding : utf-8 -*-
class LandingPagesController < ApplicationController
  layout 'application'

  def show
  end

  def olookmovel
    @campaign_email = CampaignEmail.new
  end

  def create_olookmovel
    @campaign_email = CampaignEmail.new(params[:campaign_email])
    if @campaign_email.save
      @ok = 1
      cookies['newsletterUser'] = { value: '2', path: '/', expires: 30.years.from_now }
    end
    render 'olookmovel'
  end

  def mother_day
  end

end
