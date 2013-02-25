# -*- encoding : utf-8 -*-
class Admin::CollectionThemeGroupsController < Admin::BaseController
  respond_to :html, :js

  before_filter :load_collections, only: [:update, :create, :destroy]

  load_and_authorize_resource

  def index
    @collection_theme_groups = CollectionThemeGroup.order("position")
    respond_with :admin, @collection_theme_groups
  end

  def show
    @collection_theme_group = CollectionThemeGroup.find(params[:id])
    respond_with :admin, @collection_theme_group
  end

  def create
    @collection_theme_group = CollectionThemeGroup.new(params[:collection_theme_group])
    if @collection_theme_group.save
      flash[:notice] = 'Collection Theme Group was successfully created.'
    end
    redirect_if_called_remotely
  end

  def update
    @collection_theme_group = CollectionThemeGroup.find(params[:id])

    if @collection_theme_group.update_attributes(params[:collection_theme_group])
      flash[:notice] = 'Collection Theme Group was successfully updated.'
    end

    redirect_if_called_remotely
  end

  def destroy
    @collection_theme_group = CollectionThemeGroup.find(params[:id])
    @collection_theme_group.destroy  
    redirect_if_called_remotely  
  end

  private 
  def load_collections
    @collection_theme_groups = CollectionThemeGroup.order("position") if request.xhr?
  end

  def redirect_if_called_remotely
    request.xhr? ? respond_with(:admin, @collection_theme_group) : redirect_to(admin_collection_theme_groups_path)
  end       
end