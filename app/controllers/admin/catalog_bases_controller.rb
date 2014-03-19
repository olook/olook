# encoding: utf-8
class Admin::CatalogBasesController < Admin::BaseController
  load_and_authorize_resource :class => "CatalogBase"
  respond_to :html, :text

  def index
    @search = CatalogBase.search(params[:search])
    @catalog_bases = @search.relation.page(params[:page]).per_page(50)
  end

  def show
    @catalog_base = CatalogBase.find(params[:id])
  end

  def new
    @catalog_base = CatalogBase.new(type: params[:type])
  end

  def edit
    @catalog_base = CatalogBase.find(params[:id])
  end

  def create
    @catalog_base = CatalogBase.factory(params[:catalog_base])
    if @catalog_base.save
      redirect_to admin_catalog_bases_path, notice: "Landing de catálogo criado com sucesso."
    else
      render action: "new"
    end

  end

  def update
    @catalog_base = CatalogBase.find(params[:id])
    if @catalog_base.update_attributes(params[:catalog_base])
      redirect_to admin_catalog_bases_path, notice: 'Landing de catálogo atualizado com sucesso.'
    else
      render action: "edit"
    end

  end

  def destroy
    @catalog_base = CatalogBase.find(params[:id])
    @catalog_base.destroy
    redirect_to admin_catalog_bases_path
  end

end
