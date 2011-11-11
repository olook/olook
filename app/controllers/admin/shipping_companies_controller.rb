# -*- encoding : utf-8 -*-
class Admin::ShippingCompaniesController < ApplicationController
  before_filter :authenticate_admin!

  layout "admin"
  respond_to :html

  def index
    @shipping_companies = ShippingCompany.all
    respond_with :admin, @shipping_companies
  end

  def show
    @shipping_company = ShippingCompany.find(params[:id])
    @freight_prices = @shipping_company.freight_prices.page(params[:page]).per_page(20)
    respond_with :admin, @shipping_company, @freight_prices
  end

  def new
    @shipping_company = ShippingCompany.new
    respond_with :admin, @shipping_company
  end

  def edit
    @shipping_company = ShippingCompany.find(params[:id])
    respond_with :admin, @shipping_company
  end

  def create
    @shipping_company = ShippingCompany.new(params[:shipping_company])
    
    if @shipping_company.save
      upload_freight_prices
      flash[:notice] = 'Shipping company was successfully created.'
    end

    respond_with :admin, @shipping_company
  end

  def update
    @shipping_company = ShippingCompany.find(params[:id])

    if @shipping_company.update_attributes(params[:shipping_company])
      upload_freight_prices
      flash[:notice] = 'Shipping company was successfully updated.'
    end

    respond_with :admin, @shipping_company
  end

  def destroy
    @shipping_company = ShippingCompany.find(params[:id])
    @shipping_company.destroy
    respond_with :admin, @shipping_company
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
