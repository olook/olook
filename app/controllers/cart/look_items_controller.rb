class Cart::LookItemsController < ApplicationController
  respond_to :json
  def create
    product = Product.find(params[:product_id])
    @variant_numbers = product.variants.map{|v| v.number}

    render json: {
      product_id: product.id,
      product_price: product.retail_price,
      variant_number: params[:variant_number],
      variant_numbers: @variant_numbers,
    }
  end
end
