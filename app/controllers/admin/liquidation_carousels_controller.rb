class Admin::LiquidationCarouselsController < Admin::BaseController
  before_filter :load_liquidation
  respond_to :html, :text

  def index
  end

  def create
    @carousel = LiquidationCarousel.new(params[:liquidation_carousel])
    if @carousel.save
      flash[:notice] = 'Liquidation Carosel was successfully created.'
    end
    redirect_to :action => index
  end

  def destroy
    @carousel = LiquidationCarousel.find(params[:id])
    @carousel.destroy
    redirect_to :action => index
  end
  
  private

  def load_liquidation
    @liquidation = Liquidation.find(params[:liquidation_id].to_i)
    @liquidation_carousels = LiquidationCarousel.where( :liquidation_id => @liquidation.id )
    @liquidation_carousel = LiquidationCarousel.new
  end

end