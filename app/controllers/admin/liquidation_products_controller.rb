class Admin::LiquidationProductsController < Admin::BaseController
  before_filter :load_liquidation

  def index
    @products = @liquidation.liquidation_products
  end

  def create
    #LiquidationProductsService.new(@liquidation.id, params[:products_ids], params[:discount_percent]).process
  end

  private

  def load_liquidation
    @liquidation = Liquidation.find(params[:liquidation_id])
  end

end
