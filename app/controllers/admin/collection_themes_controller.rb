class Admin::CollectionThemesController < Admin::BaseController

  load_and_authorize_resource

  respond_to :html, :text

  def index
    @groups = CollectionThemeGroup.includes(:collection_themes).order(:position)
    @collection_themes = CollectionTheme.where(collection_theme_group_id: nil).order(:position)
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
    generate_slug(params[:collection_theme]["name"])
    @collection_theme = CollectionTheme.new(params[:collection_theme])

    if @collection_theme.save
      flash[:notice] = 'CollectionTheme page was successfully created.'
    end
    respond_with :admin, @collection_theme
  end

  def update
    @collection_theme = CollectionTheme.find(params[:id])

    if @collection_theme.update_attributes(params[:collection_theme])
      flash[:notice] = 'CollectionTheme page was successfully updated.'
    end
    respond_with :admin, @collection_theme
  end

  def destroy
    @collection_theme = CollectionTheme.find(params[:id])
    @collection_theme.destroy
    respond_with :admin, @collection_theme
  end

  private

  def generate_slug(name)
  end

end
