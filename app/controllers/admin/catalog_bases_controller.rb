# encoding: utf-8
class Admin::CatalogBasesController < Admin::BaseController
  load_and_authorize_resource :class => "CatalogHeader::CatalogBase"
  respond_to :html, :text
  helper_method :resource_path, :resources_path, :new_resource_path, :edit_resource_path

  def index
    @catalog_bases = CatalogHeader::CatalogBase
    @catalog_bases = @catalog_bases.with_type(params[:type]).page(params[:page]).per_page(100)
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
      redirect_to resources_path, notice: "Landing de catálogo criado com sucesso."
    else
      render action: "new"
    end

  end

  def update
    @catalog_base = CatalogHeader::CatalogBase.find(params[:id])
    if @catalog_base.update_attributes(params[:catalog_base])
      redirect_to resources_path, notice: 'Landing de catálogo atualizado com sucesso.'
    else
      render action: "edit"
    end

  end

  def destroy
    @catalog_base = CatalogHeader::CatalogBase.find(params[:id])
    @catalog_base.destroy
    redirect_to resources_path
  end

  private

  def new_resource_path
    if is_text_header?
      admin_new_catalog_basis_text_path
    else
      admin_new_catalog_basis_banner_path
    end
  end

  def edit_resource_path(resource)
    if is_text_header?
      admin_edit_catalog_basis_text_path(resource)
    else
      admin_edit_catalog_basis_banner_path(resource)
    end
  end

  def resource_path(resource)
    if is_text_header?
      admin_catalog_basis_text_path(resource)
    else
      admin_catalog_basis_banner_path(resource)
    end
  end

  def resources_path
    if is_text_header?
      admin_catalog_bases_text_path
    else
      admin_catalog_bases_banner_path
    end
  end

  def is_text_header?
    params[:type].to_a.include?("CatalogHeader::TextCatalogHeader")
  end
end
