class Cart::LookItemsController < ApplicationController
  respond_to :json
  def create
    product = Product.find(params[:product_id])

    render json: {
      product_id: product.id,
      product_price: product.retail_price
    }
  end
end
