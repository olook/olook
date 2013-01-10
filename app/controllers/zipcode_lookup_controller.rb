class ZipcodeLookupController < ApplicationController

  respond_to :json, :js

  def get_address_by_zipcode
    result = ZipCodeAdapter.get_address(params[:zipcode])
    render json: result
  end

  def address_data
    @result = ZipCodeAdapter.get_address(params[:zip_code])
    @freight = FreightCalculator.freight_for_zip params[:zip_code], @cart_service.subtotal
  end

end
