class LiquidationsController < ApplicationController
  layout "liquidation"
  respond_to :html, :js

  def show
    if params[:category]
    @products = Product.where(:category => params[:category]).paginate(:page => params[:page], :per_page => 5)
    else
    @products = Product.paginate(:page => params[:page], :per_page => 5)
    end
    respond_with @products
  end

  def update
    if params[:category]
    @products = Product.where(:category => params[:category]).paginate(:page => params[:page], :per_page => 5)
    else
    @products = Product.paginate(:page => params[:page], :per_page => 5)
    end

    respond_with @products
  end
end
