# -*- encoding : utf-8 -*-
class LandingPagesController < ApplicationController
  layout :custom_page


  def show
    @landing_page = LandingPage.find_by_page_url!(params[:page_url])
    redirect_to root_path unless @landing_page.enabled?
  end

  def mother_day
  end

  private
  def custom_page
    case action_name
    when 'mother_day'
      "landing"
    else
      "application"
    end
  end
end
