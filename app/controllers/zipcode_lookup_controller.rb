class ZipcodeLookupController < ApplicationController

  respond_to :json, :js

  def get_address_by_zipcode
    result = ZipCodeAdapter.get_address(params[:zipcode])
    render json: result
  end

  def address_data
    result = ZipCodeAdapter.get_address(params[:zip_code])
    result.delete(:result_type)


    @freight_price = FreightCalculator.freight_for_zip(params[:zip_code], @cart_service.cart.subtotal)[:price].to_s

    @address = @user.addresses.build(:first_name => @user.first_name, :last_name => @user.last_name)
    @address.zip_code = params[:zip_code]
    @address.assign_attributes result
  end

end
