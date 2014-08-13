class ClippingsController < ApplicationController
  layout 'lite_application'
  def index
    @hide_fb_page_id = true
    @clippings = if params[:period].blank?
      Clipping.page(params[:page]).per_page(10).latest
    elsif params[:period] == "ultimos"
      Clipping.by_month_period(6).page(params[:page]).per_page(10).latest
    else
      Clipping.by_year(params[:period]).page(params[:page]).per_page(10).latest
    end
  end
end
