class WishedProductsController < ApplicationController
  
  before_filter :authenticate_user!
  respond_to :json

  def create
    product_id = params[:product_id]
    variant = Product.find(product_id).variants.first
    Wishlist.for(current_user).add variant
    render json: {message: 'Adicionado com sucesso'}
  end

  def delete
  end
end
