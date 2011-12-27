# -*- encoding : utf-8 -*-
class Admin::CollectionsController < Admin::BaseController
  respond_to :html

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
      flash[:notice] = 'Shipping service was successfully created.'
    end

    respond_with :admin, @collection
  end

  def update
    @collection = Collection.find(params[:id])

    if @collection.update_attributes(params[:collection])
      flash[:notice] = 'Shipping service was successfully updated.'
    end

    respond_with :admin, @collection
  end

  def destroy
    @collection = Collection.find(params[:id])
    @collection.destroy
    respond_with :admin, @collection
  end
end
