class Admin::LiquidationProductsController < Admin::BaseController
  before_filter :load_liquidation

  def index
    @products = @liquidation.liquidation_products
  end

  def add_or_update_products
    @product_ids = params[:product_ids]
  end

  private

  def load_liquidation
    @liquidation = Liquidation.find(params[:liquidation_id])
  end

end
