class BetaController < ApplicationController
  def index
    render layout: 'lite_checkout'
  end

  def confirmation
    render layout: 'lite_checkout'
  end

end
