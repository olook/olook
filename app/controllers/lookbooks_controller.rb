class LookbooksController < ApplicationController
  def show
    @lookbook = params[:name] ? Lookbook.where(:slug => params[:name]).active.first : Lookbook.active.first
    @products = []
    products = @lookbook.products
    products.each do |product|
      @products << Product.remove_color_variations(product.all_colors)[0]
    end
    @products_id = @lookbook.lookbooks_products.map{|item| ( item.criteo ) ? item.product_id : nil }.compact
    @lookbooks = Lookbook.active.all
    @url = request.protocol + request.host
    @facebook_app_id = FACEBOOK_CONFIG["app_id"]
  end

end
