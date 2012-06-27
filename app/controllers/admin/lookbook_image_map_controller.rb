class Admin::LookbookImageMapController < ApplicationController
  respond_to :js, :html
  
  def index
    @lookbook_image_maps = LookbookImageMap.all
    respond_with :admin, @lookbook_product_maps
  end

  def show
    @lookbook_image_map = LookbookImageMap.find(params[:id])
    respond_with :admin, @lookbook_image_map
  end

  def new
    @lookbook_image_map = LookbookImageMap.new
    respond_with :admin, @lookbook_image_map
  end

  def edit
    @lookbook_image_map = LookbookImageMap.find(params[:id])
    respond_with :admin, @lookbook_image_map
  end

  def create
    @lookbook_image_map = LookbookImageMap.new(params[:lookbook_image_map])
    if @lookbook_image_map.save
      flash[:notice] = 'Lookbook Image Map was successfully created.'
    end
    respond_with :admin, @lookbook_image_map
  end

  def update
    @lookbook_image_map = LookbookImageMap.find(params[:id])
    if @lookbook_image_map.update_attributes(params[:lookbook_image_map])
      flash[:notice] = 'Lookbook Image Map was successfully updated.'
    end
    respond_with :admin, @lookbook_image_map
  end

  def destroy
    @lookbook_image_map = LookbookImageMap.find(params[:id])
    @lookbook_image_map.destroy
    respond_with :admin, @lookbook_image_map
  end
end
