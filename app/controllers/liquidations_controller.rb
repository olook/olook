class LiquidationsController < ApplicationController
  layout "liquidation"
  respond_to :html, :js

  def show
    @liquidation = Liquidation.find(params[:id])
    @liquidation_products = LiquidationProduct.joins(:product).
                                               where("liquidation_products.liquidation_id = ?", @liquidation.id).
                                               paginate(:page => params[:page], :per_page => 15).order('category asc').
                                               group("liquidation_products.product_id")
    respond_with @liquidation_products
  end

  def update
    @liquidation = Liquidation.find(params[:id])

    subcategories = params[:subcategories] if params[:subcategories]
    shoe_sizes = params[:shoe_sizes] if params[:shoe_sizes]
    heels = params[:heels] if params[:heels]


    @liquidation_products = LiquidationProduct.joins(:product).where("liquidation_products.liquidation_id = ? AND
                                                                     (liquidation_products.subcategory_name IN (?) OR
                                                                      liquidation_products.shoe_size IN (?) OR
                                                                      liquidation_products.heel IN (?))", params[:id],
                                                                                                          subcategories,
                                                                                                          shoe_sizes,
                                                                                                          heels).
                                                                      order('category asc').
                                                                      group("liquidation_products.product_id").
                                                                      paginate(:page => params[:page], :per_page => 12)
    respond_with @liquidation_products
  end
end
