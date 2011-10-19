# -*- encoding : utf-8 -*-
class Admin::DetailsController < ApplicationController
  layout "admin"
  respond_to :html
  before_filter :load_product

  def show
    @detail = @product.details.find(params[:id])
    respond_with :admin, @detail
  end

  def new
    @detail = @product.details.build
    respond_with :admin, @product, @detail
  end

  def edit
    @detail = @product.details.find(params[:id])
    respond_with :admin, @product, @detail
  end

  def create
    @detail = @product.details.build(params[:detail])

    if @detail.save
      flash[:notice] = 'Detail was successfully created.'
    end

    respond_with :admin, @product, @detail
  end

  def update
    @detail = @product.details.find(params[:id])

    if @detail.update_attributes(params[:detail])
      flash[:notice] = 'Detail was successfully updated.'
    end

    respond_with :admin, @product, @detail
  end

  def destroy
    @detail = @product.details.find(params[:id])
    @detail.destroy
    respond_with [:admin, @product]
  end

  private
  def load_product
    @product = Product.find(params[:product_id])
  end
end
