# -*- encoding : utf-8 -*-
class Admin::ProductsController < Admin::BaseController
  respond_to :html

  def index
    @products = Product.all
    respond_with :admin, @products
  end

  def show
    @product = Product.find(params[:id])
    @related_product = RelatedProduct.new
    respond_with :admin, @product
  end

  def new
    @product = Product.new
    respond_with :admin, @product
  end

  def edit
    @product = Product.find(params[:id])
    respond_with :admin, @product
  end

  def create
    @product = Product.new(params[:product])

    if @product.save
      flash[:notice] = 'Product was successfully created.'
    end

    respond_with :admin, @product
  end

  def update
    @product = Product.find(params[:id])

    if @product.update_attributes(params[:product])
      flash[:notice] = 'Product was successfully updated.'
    end

    respond_with :admin, @product
  end

  def destroy
    @product = Product.find(params[:id])
    @product.destroy
    respond_with :admin, @product
  end

  def add_related
    @product = Product.find(params[:id])
    product_to_relate = Product.find(params[:related_product][:id])
    @product.relate_with_product(product_to_relate)

    redirect_to admin_product_path(@product)
  end

  def remove_related
    @product = Product.find(params[:id])
    related_product = Product.find(params[:related_product_id])
    @product.unrelate_with_product(related_product)

    redirect_to admin_product_path(@product)
  end
end
