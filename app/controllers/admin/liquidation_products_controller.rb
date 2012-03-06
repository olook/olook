class Admin::LiquidationProductsController < Admin::BaseController
  before_filter :load_liquidation

  def index
    @products = @liquidation.liquidation_products
  end

  def create
    liquidation_service = LiquidationService.new(@liquidation.id)
    liquidation_service.add(params[:liquidation_products][:products_ids], params[:liquidation_products][:discount_percent])
    flash[:notice] = "Products added to this liquidation"
    redirect_to admin_liquidation_products_path(@liquidation.id)
  end

  private

  def load_liquidation
    @liquidation = Liquidation.find(params[:liquidation_id])
  end

end
