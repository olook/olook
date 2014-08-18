class BetaController < ApplicationController
  def index
    render layout: 'lite_checkout'
  end

  def confirmation
    @order = Order.find_by_number(params[:number])
    @has_long_cart = !!params[:lc]
    render layout: 'lite_checkout'
  end

end
