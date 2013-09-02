class ClippingsController < ApplicationController
  def index
    @clippings = Clipping.page(params[:page]).per_page(10).latest
  end
end
