class LiquidationsController < ApplicationController
  layout "liquidation"
  respond_to :html, :js

  def show
    subcategory_names = params[:subcategories] if params[:subcategories]
    shoe_sizes        = params[:shoe_sizes] if params[:shoe_sizes]
    heels             = params[:heels] if params[:heels]

    liquidation_products = LiquidationProduct.arel_table

    @products = Product.joins(:liquidation_products).
                        where(liquidation_products["subcategory_name"].in(subcategory_names).
                        or(liquidation_products["shoe_size"].in(shoe_sizes).
                        or(liquidation_products["heel"].in(heels))))

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
