class Admin::LiquidationCarouselsController < Admin::BaseController
  before_filter :load_liquidation
  respond_to :html, :text

  def index
  end

  def edit
    @liquidation_carousel = LiquidationCarousel.find(params[:id])
  end

  def create
    @carousel = LiquidationCarousel.new(params[:liquidation_carousel])
    if @carousel.save
      flash[:notice] = 'liquidation carosel was successfully created.'
    else
      flash[:error] = 'an error appears the product is not related with liquidation'
    end
    redirect_to :action => index
  end

  def update
    @liquidation_carousel = LiquidationCarousel.find(params[:liquidation_carousel][:id])
    @liquidation_carousel.update_attributes(params[:liquidation_carousel])
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
