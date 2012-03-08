class LiquidationsController < ApplicationController
  layout "liquidation"
  respond_to :html, :js

  def show
    liquidation_products = LiquidationProduct.arel_table

    @products = Product.joins(:liquidation_products).
                        where(liquidation_products["subcategory_name"].in(params[:subcategories]).
                        or(liquidation_products["shoe_size"].in(params[:shoe_sizes]).
                        or(liquidation_products["heel"].in(params[:heels])))).order('category asc')

    respond_with @products
  end

  def update
    if params[:category]
      @products = Product.where(:category => params[:category]).paginate(:page => params[:page], :per_page => 8)
    else
      @products = Product.paginate(:page => params[:page], :per_page => 8)
    end
    respond_with @products
  end
end
