class Cart::LookItemsController < ApplicationController
  respond_to :js
  def create
    @variant_numbers = Product.find(params[:product_id]).variants.map{|v| v.number}
  end
end
