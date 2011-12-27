# -*- encoding : utf-8 -*-
class Admin::VariantsController < Admin::BaseController
  before_filter :load_product
  respond_to :html

  def show
    @variant = @product.variants.find(params[:id])
    respond_with :admin, @variant
  end

  def new
    @variant = @product.variants.build
    respond_with :admin, @product, @variant
  end

  def edit
    @variant = @product.variants.find(params[:id])
    respond_with :admin, @product, @variant
  end

  def create
    @variant = @product.variants.build(params[:variant])

    if @variant.save
      flash[:notice] = 'Variant was successfully created.'
    end

    respond_with :admin, @product, @variant
  end

  def update
    @variant = @product.variants.find(params[:id])

    if @variant.update_attributes(params[:variant])
      flash[:notice] = 'Variant was successfully updated.'
    end

    respond_with :admin, @product, @variant
  end

  def destroy
    @variant = @product.variants.find(params[:id])
    @variant.destroy
    respond_with [:admin, @product]
  end

  private
  def load_product
    @product = Product.find(params[:product_id])
  end
end
