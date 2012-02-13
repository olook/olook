class LookbooksController < ApplicationController
  def show
    if params[:name]
      @lookbook = Lookbook.where("slug = '#{params[:name]}' and active = 1").order("created_at DESC")[0]
    else
      @lookbook = Lookbook.where("active = 1").order("created_at DESC").limit(1)[0]
    end
    @products = @lookbook.products
    @products_id = @lookbook.lookbooks_products.map{|item| ( item.criteo ) ? item.product_id : nil }.compact
    @lookbooks = Lookbook.where("active = 1").order("created_at DESC")
  end

end
