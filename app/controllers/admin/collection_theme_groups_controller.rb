# -*- encoding : utf-8 -*-
class Admin::CollectionThemeGroupsController < Admin::BaseController
  respond_to :html, :js

  load_and_authorize_resource

  def index
    @collection_theme_groups = CollectionThemeGroup.all
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
    respond_with :admin, @collection_theme_group
  end

  def update
    @collection_theme_group = CollectionThemeGroup.find(params[:id])
    if @collection_theme_group.update_attributes(params[:collection_theme_group])
      flash[:notice] = 'Collection Theme Group was successfully updated.'
    end
    respond_with :admin, @collection_theme_group
  end

  def destroy
    @collection_theme_group = CollectionThemeGroup.find(params[:id])
    @collection_theme_group.destroy
    respond_with :admin, @collection_theme_group
  end       
end