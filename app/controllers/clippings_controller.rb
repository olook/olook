class ClippingsController < ApplicationController
  def index
    @hide_fb_page_id = true
    @clippings = Clipping.page(params[:page]).per_page(10).latest
  end
end
