# -*- encoding : utf-8 -*-
class Admin::ShippingServicesController < Admin::BaseController
  respond_to :html

  def index
    @shipping_services = ShippingService.all
    respond_with :admin, @shipping_services
  end

  def show
    @shipping_service = ShippingService.find(params[:id])
    @freight_prices = @shipping_service.freight_prices.page(params[:page]).per_page(20)
    respond_with :admin, @shipping_service, @freight_prices
  end

  def new
    @shipping_service = ShippingService.new
    respond_with :admin, @shipping_service
  end

  def edit
    @shipping_service = ShippingService.find(params[:id])
    respond_with :admin, @shipping_service
  end

  def create
    @shipping_service = ShippingService.new(params[:shipping_service])

    if @shipping_service.save
      upload_freight_prices
      flash[:notice] = 'Shipping service was successfully created.'
    end

    respond_with :admin, @shipping_service
  end

  def update
    @shipping_service = ShippingService.find(params[:id])

    if @shipping_service.update_attributes(params[:shipping_service])
      upload_freight_prices
      flash[:notice] = 'Shipping service was successfully updated.'
    end

    respond_with :admin, @shipping_service
  end

  def destroy
    @shipping_service = ShippingService.find(params[:id])
    @shipping_service.destroy
    respond_with :admin, @shipping_service
  end

protected

  def upload_freight_prices
    if params[:freight_prices]
      temp_file_uploader = TempFileUploader.new
      temp_file_uploader.store!(params[:freight_prices])
      Resque.enqueue(ImportFreightPricesWorker, params[:id], temp_file_uploader.filename)
    end
  end
end
