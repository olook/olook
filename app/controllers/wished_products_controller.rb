class WishedProductsController < ApplicationController
  
  before_filter :authenticate_user!
  respond_to :json

  def create
    variant = Variant.find(params[:variant_id])
    Wishlist.for(current_user).add variant
    render json: {message: 'Adicionado com sucesso'}
  end

  def destroy
    product = Product.find params[:id]
    wishlist = Wishlist.for(current_user)
    product.variants.each {|variant| wishlist.remove variant.number}
    render json: {message: 'Removido com sucesso'}
  end
end
