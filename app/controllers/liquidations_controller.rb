class LiquidationsController < ApplicationController
  layout "liquidation"
  respond_to :html, :js

  def show
    @liquidation = Liquidation.find(params[:id])
    @products = Product.joins(:liquidation_products).paginate(:page => params[:page], :per_page => 15).order('category asc')
    respond_with @products
  end

  def update
    @liquidation = Liquidation.find(params[:id])
    liquidation_products = LiquidationProduct.arel_table

    @products = Product.joins(:liquidation_products).
                        where(liquidation_products["subcategory_name"].in(params[:subcategories]).
                        or(liquidation_products["shoe_size"].in(params[:shoe_sizes]).
                        or(liquidation_products["heel"].in(params[:heels])))).order('category asc').
                        paginate(:page => params[:page], :per_page => 15)

    respond_with @products
  end
end
