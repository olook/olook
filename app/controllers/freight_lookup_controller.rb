class FreightLookupController < ApplicationController
  respond_to :js

  def freight_price

    zip_code = params[:zip_code].blank? ? Address.find(params[:address_id]).zip_code : params[:zip_code]

    @freight_price = FreightCalculator.freight_for_zip(zip_code, @cart_service.subtotal)[:price] 
  end
end
