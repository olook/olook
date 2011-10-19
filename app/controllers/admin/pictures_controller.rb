# -*- encoding : utf-8 -*-
class Admin::PicturesController < ApplicationController
  layout "admin"
  respond_to :html
  before_filter :load_product

  def show
    @picture = @product.pictures.find(params[:id])
    respond_with :admin, @picture
  end

  def new
    @picture = @product.pictures.build
    respond_with :admin, @product, @picture
  end

  def edit
    @picture = @product.pictures.find(params[:id])
    respond_with :admin, @product, @picture
  end

  def create
    @picture = @product.pictures.build(params[:picture])

    if @picture.save
      flash[:notice] = 'Picture was successfully created.'
    end

    respond_with :admin, @product, @picture
  end

  def update
    @picture = @product.pictures.find(params[:id])

    if @picture.update_attributes(params[:picture])
      flash[:notice] = 'Picture was successfully updated.'
    end

    respond_with :admin, @product, @picture
  end

  def destroy
    @picture = @product.pictures.find(params[:id])
    @picture.destroy
    respond_with [:admin, @product]
  end

  private
  def load_product
    @product = Product.find(params[:product_id])
  end
end
