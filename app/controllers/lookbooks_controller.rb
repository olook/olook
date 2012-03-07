class LookbooksController < ApplicationController
  def show
    @lookbook = params[:name] ? Lookbook.where(:slug => params[:name]).active.first : Lookbook.active.first
    @products = @lookbook.products
    @products_id = @lookbook.lookbooks_products.map{|item| ( item.criteo ) ? item.product_id : nil }.compact
    @lookbooks = Lookbook.active.all
    @url = request.protocol + request.host
    @facebook_app_id = FACEBOOK_CONFIG["app_id"]
  end

end
