# encoding: utf-8
class Admin::BrandsController < Admin::BaseController

  load_and_authorize_resource

  respond_to :html, :text

  def index
    @brands = Brand.all
  end

  def show
    @brand = Brand.find(params[:id])
    respond_with :admin, @brand
  end

  def new
    @brand = Brand.new
    respond_with :admin, @brand
  end

  def edit
    @brand = Brand.find(params[:id])
    respond_with :admin, @brand
  end

  def create
    @brand = Brand.new(params[:brand])

    if @brand.save
      flash[:notice] = 'Marca foi criada com sucesso.'
    end
    respond_with :admin, @brand
  end

  def update
    @brand = Brand.find(params[:id])

    if @brand.update_attributes(params[:brand])
      flash[:notice] = 'Marca foi atualizada com sucesso.'
    end
    respond_with :admin, @brand do |format|
      format.js { render :update }
    end
  end

  def destroy
    @brand = Brand.find(params[:id])
    @brand.destroy
    flash[:notice] = 'Marca destruída com sucesso.'
    respond_with :admin, @brand
  end

end
