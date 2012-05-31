# -*- encoding : utf-8 -*-
class Admin::CollectionsController < Admin::BaseController
  respond_to :html

  load_and_authorize_resource

  def index
    @collections = Collection.all
    respond_with :admin, @collections
  end

  def show
    @collection = Collection.find(params[:id])
    respond_with :admin, @collection
  end

  def new
    @collection = Collection.new
    respond_with :admin, @collection
  end

  def edit
    @collection = Collection.find(params[:id])
    respond_with :admin, @collection
  end

  def create
    @collection = Collection.new(params[:collection])
    if @collection.save
      flash[:notice] = 'Collection was successfully created.'
    end
    respond_with :admin, @collection
  end

  def update
    @collection = Collection.find(params[:id])
    if @collection.update_attributes(params[:collection])
      flash[:notice] = 'Collection was successfully updated.'
    end
    respond_with :admin, @collection
  end

  def destroy
    @collection = Collection.find(params[:id])
    @collection.destroy
    respond_with :admin, @collection
  end

  def mark_all_products_as_visible
    @collection = Collection.find(params[:collection_id])
    update_products = Product.update_all({:is_visible => true}, {collection_id: @collection.id})
    if !update_products
      flash[:error] = "Could not execute your request!"
    else
      flash[:notice] = "Marked all products as visible."
    end
    redirect_to admin_collection_path(@collection)
  end

  def mark_all_products_as_invisible
    @collection = Collection.find(params[:collection_id])
    update_products = Product.update_all({:is_visible => false}, {collection_id: @collection.id})
    if !update_products
      flash[:error] = "Could not execute your request!"
    else
      flash[:notice] = "Marked all products as invisible."
    end
    redirect_to admin_collection_path(@collection)
  end
end
