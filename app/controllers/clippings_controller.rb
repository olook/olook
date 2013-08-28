class ClippingsController < ApplicationController
  def index
    @clippings = Clipping.latest
  end
end
