class LiquidationsController < ApplicationController
  layout "liquidation"
  respond_to :html, :js

  def show
    @products = Product.paginate(:page => params[:page], :per_page => 30)
    respond_with @products
  end

end
