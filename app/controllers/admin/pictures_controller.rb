# -*- encoding : utf-8 -*-
class Admin::PicturesController < Admin::BaseController
  before_filter :load_product
  respond_to :html

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

  def new_multiple_pictures
    return redirect_to [:admin, @product], :notice => 'Product already has pictures' unless @product.pictures.empty?
    DisplayPictureOn.list.each do |display_on|
      @product.pictures.build :display_on => display_on
    end
    respond_with :admin, @product
  end

  def create_multiple_pictures
    @product.update_attributes(params[:product])
    if @product.save
      flash[:notice] = 'Pictures were successfully created.'
      redirect_to [:admin, @product]
    else
      flash[:notice] = 'Erro'
      render :new_multiple_pictures
    end
  end

  private
  def load_product
    @product = Product.find(params[:product_id])
  end
end
