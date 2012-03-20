class Admin::LiquidationsController < Admin::BaseController
  respond_to :html

  def index
    @liquidations = Liquidation.all
    respond_with :admin, @liquidations
  end

  # GET /admin/liquidations/1
  # GET /admin/liquidations/1.json
  def show
    @liquidation = Liquidation.find(params[:id])
    respond_with :admin, @liquidation
  end

  # GET /admin/liquidations/new
  # GET /admin/liquidations/new.json
  def new
    @liquidation = Liquidation.new
  end

  # GET /admin/liquidations/1/edit
  def edit
    @liquidation = Liquidation.find(params[:id])
  end

  # POST /admin/liquidations
  # POST /admin/liquidations.json
  def create
    @liquidation = Liquidation.new(params[:liquidation])
    if @liquidation.save
      flash[:notice] = 'Liquidation was successfully created.'
    end
    respond_with :admin, @liquidation
  end

  # PUT /admin/liquidations/1
  # PUT /admin/liquidations/1.json
  def update
    @liquidation = Liquidation.find(params[:id])
    if @liquidation.update_attributes(params[:liquidation])
      flash[:notice] = 'Liquidation was successfully updated.'
    end
    respond_with :admin, @liquidation
  end

  # DELETE /admin/liquidations/1
  # DELETE /admin/liquidations/1.json
  def destroy
    @liquidation = Liquidation.find(params[:id])
    @liquidation.destroy
    respond_with :admin, @liquidation
  end
  
  def fetch
    @liquidation = Liquidation.find(params[:liquidation_id])  
    LiquidationService.new(@liquidation.id).fetch!
    redirect_to admin_liquidation_path(@liquidation.id)
  end
end
