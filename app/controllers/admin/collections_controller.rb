# -*- encoding : utf-8 -*-
class Admin::CollectionsController < Admin::BaseController
  load_and_authorize_resource
  respond_to :html


  def index
    @collections = Collection.order('start_date desc')
    respond_with :admin, @collections
  end

  def show
    @collection = Collection.find(params[:id])
    @products = if params[:category] && params[:category][:id].present?
                    @collection.products.where(category: params[:category][:id]).paginate(page: params[:page], per_page: 50)
                else
                    @collection.products.paginate(page: params[:page], per_page: 100)
                end
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
    @products = @collection.products
    update_products = @products.update_all(is_visible: true)
    if !update_products
      flash[:error] = "Could not execute your request!"
    else
      ProductListener.notify_about_visibility(@products, current_admin)
      flash[:notice] = "Marked all products as visible."
    end
    redirect_to admin_collection_path(@collection)
  end

  def mark_all_products_as_invisible
    @collection = Collection.find(params[:collection_id])
    @products = @collection.products
    update_products = @products.update_all(is_visible: false)
    if !update_products
      flash[:error] = "Could not execute your request!"
    else
      ProductListener.notify_about_visibility(@products, current_admin)
      flash[:notice] = "Marked all products as invisible."
    end
    redirect_to admin_collection_path(@collection)
  end

  def mark_specific_products_as_visible
    @collection = Collection.find(params[:collection_id])

    visible_product_ids = params[:products].select { |p| p[:visibility].present? }.map {|p| p[:id] }.uniq.compact
    invisible_product_ids = params[:products].select { |p| p[:visibility].nil? }.map {|p| p[:id] }.uniq.compact

    @visible_products = @collection.products.where(id: visible_product_ids)
    @invisible_products = @collection.products.where(id: invisible_product_ids)

    @visible_products.update_all(is_visible: true)
    @invisible_products.update_all(is_visible: false)
    @products = @visible_products + @invisible_products


    ProductListener.notify_about_visibility(@products, current_admin)

    flash[:notice] = "Marked selected products as visible."
    respond_with :admin, @collection
  end
end
