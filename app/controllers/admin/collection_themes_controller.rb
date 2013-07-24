# encoding: utf-8
class Admin::CollectionThemesController < Admin::BaseController

  load_and_authorize_resource

  respond_to :html, :text

  def index
    @groups = CollectionThemeGroup.includes(:collection_themes).order(:position)
    @collection_themes = CollectionTheme.where(collection_theme_group_id: nil).order(:position)
    @groups.push(CollectionThemeGroup.new(name: 'Sem Grupo', collection_themes: @collection_themes))
  end

  def show
    @collection_theme = CollectionTheme.find(params[:id])
    respond_with :admin, @collection_theme
  end

  def new
    @collection_theme = CollectionTheme.new
    respond_with :admin, @collection_theme
  end

  def edit
    @collection_theme = CollectionTheme.find(params[:id])
    respond_with :admin, @collection_theme
  end

  def create
    @collection_theme = CollectionTheme.new(params[:collection_theme])
    if @collection_theme.save
      flash[:notice] = 'Coleção Temática foi criada com sucesso.'
    end
    respond_with :admin, @collection_theme
  end

  def update
    @collection_theme = CollectionTheme.find(params[:id])

    if @collection_theme.update_attributes(params[:collection_theme])
      flash[:notice] = 'Coleção Temática foi atualizada com sucesso.'
    else
      render "show"
    end
    respond_with :admin, @collection_theme do |format|
      format.js { render :update }
    end
  end

  def destroy
    @collection_theme = CollectionTheme.find(params[:id])
    @collection_theme.destroy
    flash[:notice] = 'Coleção Temática destruída com sucesso.'
    respond_with :admin, @collection_theme
  end

  def import
  end

  def import_create
    AssociateProductWithCollectionThemeService.new(params[:collection_products_csv]).process!
    redirect_to import_index_admin_collection_themes_path, notice: 'Adicionado as coleções com sucesso'
  end

end
