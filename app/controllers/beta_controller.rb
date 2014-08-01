class BetaController < ApplicationController
  def index
    render layout: 'lite_checkout'
  end

  def confirmation
    @has_long_cart = !!params[:lc]
    render layout: 'lite_checkout'
  end

end
