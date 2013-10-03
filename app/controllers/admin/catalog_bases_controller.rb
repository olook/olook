# encoding: utf-8
class Admin::CatalogBasesController < Admin::BaseController
  respond_to :html, :text

  def index
    @catalog_bases = CatalogHeader::CatalogBase
    if params[:type] == "CatalogHeader::TextCatalogHeader"
      @catalog_bases = @catalog_bases.with_type("CatalogHeader::TextCatalogHeader").page(params[:page]).per_page(100)
    elsif params[:search]
      params[:search] = Hash[params[:search].select{|k,v| v.present?}]
      @catalog_bases = @catalog_bases.where(params[:search])
    end

    @catalog_bases = @catalog_bases.page(params[:page]).per_page(100)
  end

  def show
    @catalog_base = CatalogHeader::CatalogBase.find(params[:id])
  end

  def new
    @catalog_base = CatalogHeader::CatalogBase.new(type: params[:type])
  end

  def edit
    @catalog_base = CatalogHeader::CatalogBase.find(params[:id])
  end

  def create
    @catalog_base = CatalogHeader::CatalogBase.factory(params[:catalog_base])
    if @catalog_base.save
      redirect_to admin_catalog_bases_path, notice: "Landing de catálogo criado com sucesso."
    else
      render action: "new"
    end

  end

  def update
    @catalog_base = CatalogHeader::CatalogBase.find(params[:id])
    if @catalog_base.update_attributes(params[:catalog_base])
      redirect_to admin_catalog_bases_path, notice: 'Landing de catálogo atualizado com sucesso.'
    else
      render action: "edit"
    end

  end

  def destroy
    @catalog_base = CatalogHeader::CatalogBase.find(params[:id])
    @catalog_base.destroy
    redirect_to admin_catalog_bases_url
  end
end
